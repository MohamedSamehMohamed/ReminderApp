import '../core/models.dart';
import '../core/recurrence.dart';

class PlannedAlarm {
  final int id;
  final Reminder reminder;
  final DateOnly date;
  final String lead;
  final DateTime fireAt;
  const PlannedAlarm(this.id, this.reminder, this.date, this.lead, this.fireAt);
  String get key => '${reminder.id}|$date|$lead';
  String get fingerprint =>
      '${fireAt.toIso8601String()}|${reminder.title}|${reminder.updatedAt}';
}

int alarmId(String s) {
  var h = 2166136261;
  for (final c in s.codeUnits) {
    h = ((h ^ c) * 16777619) & 0x7fffffff;
  }
  return h;
}

List<PlannedAlarm> planAlarms(
  List<Reminder> reminders,
  List<OccurrenceLog> logs,
  DateTime now,
) {
  final end = now.add(const Duration(days: 60));
  final byKey = {for (final l in logs) l.key: l};
  final result = <PlannedAlarm>[];
  for (final r in reminders.where((r) => r.active)) {
    for (final d in occurrences(
      r,
      DateOnly.from(now),
      DateOnly.from(end).addMonths(1),
    )) {
      final record = byKey['${r.id}|$d'];
      if (record?.status == 'done' ||
          record?.status == 'snoozed' &&
              (record!.snoozedUntil?.isAfter(now) ?? false)) {
        continue;
      }
      for (final a in leadAlerts(r, d, now)) {
        if (!a.fireAt.isAfter(end)) {
          result.add(
            PlannedAlarm(
              alarmId('${r.id}|$d|${a.lead}'),
              r,
              d,
              a.lead,
              a.fireAt,
            ),
          );
        }
      }
    }
    for (final l in logs.where(
      (l) =>
          l.reminderId == r.id &&
          l.status == 'snoozed' &&
          l.snoozedUntil != null,
    )) {
      final at = l.snoozedUntil!;
      if (!at.isBefore(now) && !at.isAfter(end)) {
        result.add(
          PlannedAlarm(
            alarmId('${r.id}|${l.date}|snooze'),
            r,
            l.date,
            'snooze',
            at,
          ),
        );
      }
    }
  }
  result.sort((a, b) {
    final c = a.fireAt.compareTo(b.fireAt);
    return c == 0 ? a.key.compareTo(b.key) : c;
  });
  final seen = <String>{};
  final ids = <int>{};
  final selected = <PlannedAlarm>[];
  for (final a in result) {
    if (!seen.add('${a.reminder.id}|${a.fireAt}')) continue;
    var id = a.id;
    while (!ids.add(id)) {
      id = (id + 1) & 0x7fffffff;
    }
    selected.add(PlannedAlarm(id, a.reminder, a.date, a.lead, a.fireAt));
    if (selected.length == 400) break;
  }
  return selected;
}

class AlarmSnapshot {
  final int id;
  final String fingerprint;
  const AlarmSnapshot(this.id, this.fingerprint);
}

({List<int> cancel, List<PlannedAlarm> schedule}) diffAlarms(
  List<AlarmSnapshot> old,
  List<PlannedAlarm> desired,
  String environment,
) {
  final wanted = {
    for (final a in desired) a.id: '${a.fingerprint}|$environment',
  };
  final previous = {for (final a in old) a.id: a.fingerprint};
  return (
    cancel: old
        .where((a) => wanted[a.id] != a.fingerprint)
        .map((a) => a.id)
        .toList(),
    schedule: desired.where((a) => previous[a.id] != wanted[a.id]).toList(),
  );
}
