import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:reminders/app/settings.dart';
import 'package:reminders/core/models.dart';
import 'package:reminders/data/database.dart';
import 'package:reminders/data/repository.dart';
import 'package:reminders/notifications/scheduler.dart';

class PluginMock extends Mock implements FlutterLocalNotificationsPlugin {}

class AndroidMock extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

class PathsMock extends PathProviderPlatform {
  final String path;
  PathsMock(this.path);
  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late Repository repo;
  late AlarmScheduler scheduler;
  late AppSettings settings;
  late PluginMock plugin;
  late AndroidMock android;
  late Directory directory;
  late PathProviderPlatform oldPaths;
  late Map<int, PendingNotificationRequest> pending;
  late List<int> cancelled;
  late List<AndroidScheduleMode> scheduled;
  setUpAll(() async {
    await initializeDateFormatting();
    registerFallbackValue(tz.TZDateTime(tz.UTC, 2026));
    registerFallbackValue(const NotificationDetails());
    registerFallbackValue(AndroidScheduleMode.exactAllowWhileIdle);
  });
  setUp(() async {
    tzdata.initializeTimeZones();
    db = AppDatabase(NativeDatabase.memory());
    repo = Repository(db, clock: FixedClock(DateTime(2026, 10, 10, 12)));
    SharedPreferences.setMockInitialValues({'language': 'en'});
    settings = AppSettings(await SharedPreferences.getInstance());
    directory = await Directory.systemTemp.createTemp('reminders-scheduler-');
    oldPaths = PathProviderPlatform.instance;
    final paths = PathsMock(directory.path);
    PathProviderPlatform.instance = paths;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_timezone'),
          (call) async => {'identifier': 'UTC'},
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(systemChannel, (call) async => true);
    plugin = PluginMock();
    android = AndroidMock();
    pending = {};
    cancelled = [];
    scheduled = [];
    when(
      () => plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >(),
    ).thenReturn(android);
    when(() => android.areNotificationsEnabled()).thenAnswer((_) async => true);
    when(() => android.canScheduleExactNotifications())
        .thenAnswer((_) async => true);
    when(() => plugin.pendingNotificationRequests())
        .thenAnswer((_) async => pending.values.toList());
    when(() => plugin.cancel(id: any(named: 'id'))).thenAnswer((inv) async {
      final id = inv.namedArguments[#id] as int;
      cancelled.add(id);
      pending.remove(id);
    });
    when(
      () => plugin.zonedSchedule(
        id: any(named: 'id'),
        scheduledDate: any(named: 'scheduledDate'),
        notificationDetails: any(named: 'notificationDetails'),
        androidScheduleMode: any(named: 'androidScheduleMode'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((inv) async {
      final id = inv.namedArguments[#id] as int;
      scheduled.add(
        inv.namedArguments[#androidScheduleMode] as AndroidScheduleMode,
      );
      pending[id] = PendingNotificationRequest(
        id,
        inv.namedArguments[#title] as String?,
        inv.namedArguments[#body] as String?,
        inv.namedArguments[#payload] as String?,
      );
    });
    scheduler = AlarmScheduler(repo, settings, notifications: plugin);
    repo.onChanged = scheduler.syncAlarms;
  });
  tearDown(() async {
    scheduler.dispose();
    settings.dispose();
    await db.close();
    PathProviderPlatform.instance = oldPaths;
    await directory.delete(recursive: true);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_timezone'),
          null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(systemChannel, null);
  });
  const reminder = Reminder(
    id: 'a',
    title: 'Test',
    anchor: DateOnly(2026, 10, 11),
  );
  test(
    'Schedules, leaves unchanged, updates and cancels deleted alarms',
    () async {
      await repo.save(reminder);
      expect(scheduled.length, 1);
      expect((await db.select(db.scheduledAlarms).get()).length, 1);
      await scheduler.syncAlarms();
      expect(scheduled.length, 1);
      await repo.save(
        const Reminder(
          id: 'a',
          title: 'Changed',
          anchor: DateOnly(2026, 10, 11),
        ),
      );
      expect(scheduled.length, 2);
      expect(cancelled.length, 1);
      await repo.delete('a');
      expect(pending, isEmpty);
      expect(cancelled.length, 2);
    },
  );
  test(
    'Falls back to inexact alarms, then Done removes the occurrence',
    () async {
      when(() => android.canScheduleExactNotifications())
          .thenAnswer((_) async => false);
      await repo.save(reminder);
      expect(scheduled.single, AndroidScheduleMode.inexactAllowWhileIdle);
      await repo.act('a', reminder.anchor, 'done');
      expect(pending, isEmpty);
    },
  );
}
