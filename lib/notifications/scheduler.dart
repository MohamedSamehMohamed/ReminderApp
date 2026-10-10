import 'dart:io';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

import '../app/settings.dart';
import '../app/strings.dart';
import '../core/models.dart';
import '../data/database.dart';
import '../data/repository.dart';
import '../app/formatting.dart';
import '../l10n/app_localizations.dart';
import 'plan.dart';

const systemChannel = MethodChannel('app.reminders/system');
@pragma('vm:entry-point')
void notificationBackground(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final db = AppDatabase();
  final repo = Repository(db);
  final prefs = await SharedPreferences.getInstance();
  final scheduler = AlarmScheduler(repo, AppSettings(prefs));
  try {
    await scheduler.initialize();
    repo.onChanged = scheduler.syncAlarms;
    await scheduler.handleAction(response);
  } finally {
    await db.close();
  }
}

@pragma('vm:entry-point')
void workDispatcher() {
  Workmanager().executeTask((task, input) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    final db = AppDatabase();
    final repo = Repository(db);
    final prefs = await SharedPreferences.getInstance();
    final scheduler = AlarmScheduler(repo, AppSettings(prefs));
    try {
      await scheduler.initialize();
      await repo.markMissed();
      await scheduler.syncAlarms();
      return true;
    } catch (e, st) {
      debugPrint('Alarm resync failed: $e\n$st');
      return false;
    } finally {
      await db.close();
    }
  });
}

class AlarmScheduler extends ChangeNotifier {
  final Repository repository;
  final AppSettings settings;
  final FlutterLocalNotificationsPlugin plugin;
  bool notificationsAllowed = true, exactAllowed = true, batteryAllowed = true;
  void Function(String)? onOpen;
  String? initialPayload;
  Future<void>? _sync;
  AlarmScheduler(
    this.repository,
    this.settings, {
    FlutterLocalNotificationsPlugin? notifications,
  }) : plugin = notifications ?? FlutterLocalNotificationsPlugin();
  AndroidFlutterLocalNotificationsPlugin? get android => plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  Future<void> initialize() async {
    tzdata.initializeTimeZones();
    await initializeDateFormatting();
    await updateZone();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
      onDidReceiveNotificationResponse: (response) async {
        if (response.actionId?.isNotEmpty ?? false) {
          await handleAction(response);
        } else if (response.payload != null) {
          onOpen?.call(response.payload!);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationBackground,
    );
    final launch = await plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      initialPayload = launch?.notificationResponse?.payload;
    }
    final l = lookupAppLocalizations(Locale(settings.arabic ? 'ar' : 'en'));
    await android?.createNotificationChannel(
      AndroidNotificationChannel(
        'reminders_due',
        l.today,
        importance: Importance.high,
      ),
    );
    await android?.createNotificationChannel(
      AndroidNotificationChannel(
        'reminders_upcoming',
        l.nextUp,
        importance: Importance.defaultImportance,
      ),
    );
    await refreshPermissions();
  }

  Future<void> updateZone() async {
    final info = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(info.identifier));
  }

  Future<void> refreshPermissions() async {
    notificationsAllowed = await android?.areNotificationsEnabled() ?? true;
    exactAllowed = await android?.canScheduleExactNotifications() ?? true;
    try {
      batteryAllowed =
          await systemChannel.invokeMethod<bool>('batteryAllowed') ?? true;
    } on MissingPluginException {
      batteryAllowed = true;
    }
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
    await refreshPermissions();
    await syncAlarms();
  }

  Future<void> handleAction(NotificationResponse response) async {
    final parts = response.payload?.split('|');
    if (parts == null || parts.length != 2) return;
    final rows = await repository.reminders();
    Reminder? r;
    for (final item in rows) {
      if (item.id == parts[0]) r = item;
    }
    if (r == null) return;
    final date = DateOnly.parse(parts[1]);
    if (response.actionId == 'done') {
      await repository.act(r.id, date, 'done');
    } else if (response.actionId == 'snooze1' ||
        response.actionId == 'snoozeTomorrow') {
      final now = repository.clock.now();
      final tomorrow = DateOnly.from(now).addDays(1);
      await repository.act(
        r.id,
        date,
        'snoozed',
        until: response.actionId == 'snooze1'
            ? now.add(const Duration(hours: 1))
            : DateTime(
                tomorrow.year,
                tomorrow.month,
                tomorrow.day,
                r.alertMinutes ~/ 60,
                r.alertMinutes % 60,
              ),
      );
    }
    if (response.id != null) await plugin.cancel(id: response.id!);
  }

  Future<void> syncAlarms() async {
    if (_sync != null) {
      await _sync;
      return syncAlarms();
    }
    final future = _performSync();
    _sync = future;
    try {
      await future;
    } finally {
      _sync = null;
    }
  }

  Future<void> _performSync() async {
    // File locking coordinates processes; the SQLite write transaction also
    // serializes isolates in the same Android process.
    final dir = await getApplicationDocumentsDirectory();
    final lock = await File('${dir.path}/alarm-sync.lock')
        .open(mode: FileMode.append);
    await lock.lock(FileLock.blockingExclusive);
    final db = repository.db;
    try {
      await db.transaction(() async {
        await db.customStatement(
          'UPDATE scheduled_alarms SET fingerprint = fingerprint',
        );
        await settings.prefs.reload();
        await updateZone();
        await refreshPermissions();
        final now = repository.clock.now();
        final desired = planAlarms(
          await repository.reminders(),
          await repository.logs(),
          now,
        );
        final stored = await db.select(db.scheduledAlarms).get();
        final pending = await plugin.pendingNotificationRequests();
        final pendingIds = pending.map((a) => a.id).toSet();
        final environment =
            '${tz.local.name}|${settings.language}|${settings.arabicDigits}|$exactAllowed';
        final diff = diffAlarms(
          stored
              .where((a) => pendingIds.contains(a.notificationId))
              .map((a) => AlarmSnapshot(a.notificationId, a.fingerprint))
              .toList(),
          desired,
          environment,
        );
        final wantedIds = desired.map((a) => a.id).toSet();
        for (final id in {
          ...diff.cancel,
          ...pendingIds.difference(wantedIds),
        }) {
          await plugin.cancel(id: id);
        }
        final l = lookupAppLocalizations(Locale(settings.arabic ? 'ar' : 'en'));
        for (final alarm in diff.schedule) {
          final r = alarm.reminder;
          final d = alarm.fireAt;
          final age = r.knownYear == null
              ? ''
              : ' · ${l.turns(numText(alarm.date.year - r.knownYear!, settings))}';
          final content =
              '${text(l, alarm.lead == 'snooze' ? 'snoozed' : alarm.lead)} · ${summary(r, l, settings)}';
          await plugin.zonedSchedule(
            id: alarm.id,
            title: '${r.title}$age',
            body: content,
            scheduledDate: tz.TZDateTime(
              tz.local,
              d.year,
              d.month,
              d.day,
              d.hour,
              d.minute,
              d.second,
            ),
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                alarm.lead == 'day0' || alarm.lead == 'snooze'
                    ? 'reminders_due'
                    : 'reminders_upcoming',
                alarm.lead == 'day0' ? l.today : l.nextUp,
                importance: alarm.lead == 'day0' || alarm.lead == 'snooze'
                    ? Importance.high
                    : Importance.defaultImportance,
                priority: Priority.high,
                icon: 'ic_notification',
                actions: [
                  AndroidNotificationAction(
                    'done',
                    l.done,
                    cancelNotification: true,
                  ),
                  AndroidNotificationAction(
                    'snooze1',
                    l.oneHour,
                    cancelNotification: true,
                  ),
                  AndroidNotificationAction(
                    'snoozeTomorrow',
                    l.tomorrow,
                    cancelNotification: true,
                  ),
                ],
              ),
            ),
            androidScheduleMode: exactAllowed
                ? AndroidScheduleMode.exactAllowWhileIdle
                : AndroidScheduleMode.inexactAllowWhileIdle,
            payload: '${r.id}|${alarm.date}',
          );
        }
        // Keep elapsed alarms until the event date passes, as evidence for missed history.
        final logged = (await repository.logs()).map((l) => l.key).toSet();
        final retain = stored
            .where(
              (a) =>
                  DateTime.parse(a.fireAt).isBefore(now) &&
                  DateOnly.parse(a.occurrenceDate)
                          .compareTo(DateOnly.from(now).addDays(-30)) >=
                      0 &&
                  !logged.contains('${a.reminderId}|${a.occurrenceDate}') &&
                  !wantedIds.contains(a.notificationId),
            )
            .toList();
        final existing = (await repository.reminders())
            .map((r) => r.id)
            .toSet();
        await db.transaction(() async {
          await db.delete(db.scheduledAlarms).go();
          for (final a in retain) {
            if (existing.contains(a.reminderId)) {
              await db.into(db.scheduledAlarms).insert(a);
            }
          }
          for (final a in desired) {
            await db
                .into(db.scheduledAlarms)
                .insert(
                  ScheduledAlarmsCompanion.insert(
                    notificationId: Value(a.id),
                    reminderId: a.reminder.id,
                    occurrenceDate: a.date.toString(),
                    lead: a.lead,
                    fireAt: a.fireAt.toIso8601String(),
                    fingerprint: '${a.fingerprint}|$environment',
                  ),
                );
          }
        });
      });
    } finally {
      await lock.unlock();
      await lock.close();
    }
  }
}
