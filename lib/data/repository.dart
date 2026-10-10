import 'dart:convert';

import 'package:drift/drift.dart';

import '../core/models.dart';
import 'database.dart';

Reminder fromRow(ReminderRow r) => Reminder(
  id: r.id,
  title: r.title,
  type: ReminderType.values.byName(r.type),
  repeat: RepeatMode.values.byName(r.repeat),
  anchor: DateOnly.parse(r.anchorDate),
  weekdays: r.weekdays,
  dayOfMonth: r.dayOfMonth,
  knownYear: r.knownYear,
  alertMinutes: r.alertMinutes,
  leads: r.leads,
  note: r.note,
  active: r.isActive,
  createdAt: r.createdAt,
  updatedAt: r.updatedAt,
);
OccurrenceLog fromLog(LogRow r) => OccurrenceLog(
  r.reminderId,
  DateOnly.parse(r.occurrenceDate),
  r.status,
  r.actedAt,
  r.snoozedUntil == null ? null : DateTime.parse(r.snoozedUntil!),
);

class Repository {
  final AppDatabase db;
  final Clock clock;
  Future<void> Function()? onChanged;
  Repository(this.db, {this.clock = const SystemClock()});
  Stream<List<Reminder>> watchReminders() => db
      .select(db.reminderRows)
      .watch()
      .map((rows) => rows.map(fromRow).toList());
  Stream<List<OccurrenceLog>> watchLogs() => db
      .select(db.occurrenceLogs)
      .watch()
      .map((rows) => rows.map(fromLog).toList());
  Future<List<Reminder>> reminders() async =>
      (await db.select(db.reminderRows).get()).map(fromRow).toList();
  Future<List<OccurrenceLog>> logs() async =>
      (await db.select(db.occurrenceLogs).get()).map(fromLog).toList();
  Future<void> save(Reminder r, {bool sync = true}) async {
    if (r.validate().isNotEmpty) {
      throw const FormatException('Invalid reminder');
    }
    final now = clock.now().toUtc().toIso8601String();
    await db
        .into(db.reminderRows)
        .insertOnConflictUpdate(
          ReminderRowsCompanion.insert(
            id: r.id,
            title: r.title,
            type: r.type.name,
            repeat: r.repeat.name,
            anchorDate: r.anchor.toString(),
            weekdays: r.weekdays,
            dayOfMonth: r.dayOfMonth,
            knownYear: Value(r.knownYear),
            alertMinutes: r.alertMinutes,
            leads: r.leads,
            note: Value(r.note),
            isActive: Value(r.active),
            createdAt: r.createdAt.isEmpty ? now : r.createdAt,
            updatedAt: now,
          ),
        );
    if (sync) await onChanged?.call();
  }

  Future<void> delete(String id) async {
    await (db.delete(db.reminderRows)..where((r) => r.id.equals(id))).go();
    await onChanged?.call();
  }

  Future<void> act(
    String id,
    DateOnly date,
    String status, {
    DateTime? until,
    bool sync = true,
    String? actedAt,
  }) async {
    await db
        .into(db.occurrenceLogs)
        .insertOnConflictUpdate(
          OccurrenceLogsCompanion.insert(
            reminderId: id,
            occurrenceDate: date.toString(),
            status: status,
            snoozedUntil: Value(until?.toIso8601String()),
            actedAt: actedAt ?? clock.now().toUtc().toIso8601String(),
          ),
        );
    if (sync) await onChanged?.call();
  }

  Future<void> markMissed() async {
    final now = clock.now();
    final today = DateOnly.from(now);
    final seen = (await logs()).map((l) => l.key).toSet();
    final active = (await reminders())
        .where((r) => r.active)
        .map((r) => r.id)
        .toSet();
    for (final alarm in await db.select(db.scheduledAlarms).get()) {
      final d = DateOnly.parse(alarm.occurrenceDate);
      final key = '${alarm.reminderId}|$d';
      if (active.contains(alarm.reminderId) &&
          d.compareTo(today) < 0 &&
          d.compareTo(today.addDays(-30)) >= 0 &&
          DateTime.parse(alarm.fireAt).isBefore(now) &&
          seen.add(key)) {
        await act(alarm.reminderId, d, 'missed', sync: false);
      }
    }
  }

  Future<String> exportJson() async =>
      const JsonEncoder.withIndent('  ').convert({
        'version': 1,
        'reminders': (await reminders()).map((r) => r.toJson()).toList(),
        'occurrence_log': (await logs()).map((l) => l.toJson()).toList(),
      });
  Future<void> importJson(String source, {required bool merge}) async {
    final data = jsonDecode(source) as Map<String, dynamic>;
    if (data['version'] != 1) {
      throw const FormatException('Unsupported backup version');
    }
    final items = (data['reminders'] as List)
        .map((e) => Reminder.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final records = (data['occurrence_log'] as List)
        .map((e) => OccurrenceLog.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    if (items.any((r) => r.validate().isNotEmpty) ||
        records.any(
          (l) =>
              !['done', 'missed', 'snoozed'].contains(l.status) ||
              (l.status == 'snoozed' && l.snoozedUntil == null),
        )) {
      throw const FormatException('Invalid backup');
    }
    await db.transaction(() async {
      if (!merge) await db.delete(db.reminderRows).go();
      for (final r in items) {
        await save(r, sync: false);
      }
      final ids = (await reminders()).map((r) => r.id).toSet();
      for (final l in records) {
        if (!ids.contains(l.reminderId)) {
          throw const FormatException('Unknown reminder');
        }
        await act(
          l.reminderId,
          l.date,
          l.status,
          until: l.snoozedUntil,
          sync: false,
          actedAt: l.actedAt,
        );
      }
    });
    await onChanged?.call();
  }
}
