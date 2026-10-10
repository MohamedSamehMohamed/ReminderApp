import 'package:drift/native.dart';
import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:reminders/app/providers.dart';
import 'package:reminders/app/settings.dart';
import 'package:reminders/app/tokens.dart';
import 'package:reminders/core/models.dart';
import 'package:reminders/data/database.dart';
import 'package:reminders/data/repository.dart';
import 'package:reminders/features/home/home_screen.dart';
import 'package:reminders/features/editor/editor_screen.dart';
import 'package:reminders/features/detail/detail_screen.dart';
import 'package:reminders/features/calendar/calendar_screen.dart';
import 'package:reminders/features/settings/settings_screen.dart';
import 'package:reminders/l10n/app_localizations.dart';
import 'package:reminders/main.dart';
import 'package:reminders/notifications/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late Repository repo;
  late AppSettings settings;
  late AlarmScheduler scheduler;
  setUpAll(() async {
    await initializeDateFormatting();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    for (final font in [
      ('Plus Jakarta Sans', 'PlusJakartaSans.ttf'),
      ('IBM Plex Sans Arabic', 'IBMPlexSansArabic-Regular.ttf'),
    ]) {
      final loader = FontLoader(font.$1)
        ..addFont(rootBundle.load('assets/fonts/${font.$2}'));
      await loader.load();
    }
  });
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = Repository(db, clock: FixedClock(DateTime(2026, 10, 10, 12)));
    SharedPreferences.setMockInitialValues({'onboarded': true});
    settings = AppSettings(await SharedPreferences.getInstance());
    scheduler = AlarmScheduler(repo, settings);
  });
  tearDown(() async {
    scheduler.dispose();
    settings.dispose();
    await db.close();
  });
  Future<void> seed() async {
    for (final r in [
      const Reminder(
        id: 'omar',
        title: "Omar's birthday",
        type: ReminderType.birthday,
        repeat: RepeatMode.yearly,
        anchor: DateOnly(1996, 10, 12),
        knownYear: 1996,
      ),
      const Reminder(
        id: 'bill',
        title: 'Pay internet bill',
        type: ReminderType.bill,
        repeat: RepeatMode.monthly,
        anchor: DateOnly(2026, 1, 15),
        dayOfMonth: 15,
      ),
      const Reminder(
        id: 'grandma',
        title: 'Call grandma',
        repeat: RepeatMode.weekly,
        anchor: DateOnly(2026, 1, 1),
        weekdays: 16,
        alertMinutes: 1140,
      ),
      const Reminder(
        id: 'mom',
        title: "Mom's birthday",
        type: ReminderType.birthday,
        repeat: RepeatMode.yearly,
        anchor: DateOnly(1968, 10, 24),
        knownYear: 1968,
      ),
    ]) {
      await repo.save(r);
    }
  }

  Future<void> pump(
    WidgetTester tester,
    String path, {
    bool wholeApp = false,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final currentRows = await repo.reminders();
    final currentLogs = await repo.logs();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: HomeScreen()),
        ),
        GoRoute(path: '/editor', builder: (_, _) => const EditorScreen()),
        GoRoute(
          path: '/calendar',
          builder: (_, _) => const Scaffold(body: CalendarScreen()),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, _) => const Scaffold(body: SettingsScreen()),
        ),
        GoRoute(
          path: '/detail/:id',
          builder: (_, s) => DetailScreen(s.pathParameters['id']!),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          remindersProvider.overrideWith((ref) => Stream.value(currentRows)),
          logsProvider.overrideWith((ref) => Stream.value(currentLogs)),
          repositoryProvider.overrideWithValue(repo),
          settingsProvider.overrideWithValue(settings),
          schedulerProvider.overrideWithValue(scheduler),
        ],
        child: wholeApp
            ? const RemindersApp()
            : MaterialApp.router(
                debugShowCheckedModeBanner: false,
                locale: Locale(settings.arabic ? 'ar' : 'en'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: Tokens.theme(
                  settings.theme == ThemeMode.dark,
                  settings.arabic,
                ),
                routerConfig: router,
              ),
      ),
    );
    await tester.pumpAndSettle();
    if (path != '/') {
      if (wholeApp) {
        GoRouter.of(tester.element(find.byType(HomeScreen))).go(path);
      } else {
        router.push(path);
      }
      await tester.pumpAndSettle();
    }
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('Editor blocks empty title and no weekday', (tester) async {
    await pump(tester, '/editor');
    await tester.scrollUntilVisible(
      find.text('Save reminder'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Save reminder'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a title with 1–80 characters'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('title')),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(find.byKey(const Key('title')), 'Call');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Weekly'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Weekly'));
    await tester.pumpAndSettle();
    expect(find.text('Weekdays'), findsOneWidget);
    await tester.ensureVisible(find.text('Sat'));
    await tester.tap(find.text('Sat'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save reminder'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save reminder'));
    await tester.pumpAndSettle();
    expect(find.text('Choose at least one weekday'), findsOneWidget);
    expect(await repo.reminders(), isEmpty);
    expect(tester.takeException(), isNull);
  });
  for (final mode in RepeatMode.values) {
    testWidgets('Saves ${mode.name} fields correctly', (tester) async {
      await pump(tester, '/editor');
      await tester.enterText(find.byKey(const Key('title')), 'Test reminder');
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
      final label = '${mode.name[0].toUpperCase()}${mode.name.substring(1)}';
      await tester.ensureVisible(find.text(label));
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save reminder'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save reminder'));
      await tester.pumpAndSettle();
      final saved = (await repo.reminders()).single;
      expect(saved.repeat, mode);
      expect(saved.title, 'Test reminder');
      expect(saved.anchor, const DateOnly(2026, 10, 10));
      expect(saved.leads, 1);
      expect(saved.alertMinutes, 540);
      if (mode == RepeatMode.weekly) expect(saved.weekdays, 32);
      if (mode == RepeatMode.monthly) expect(saved.dayOfMonth, 10);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Home groups reminders and search filters notes', (tester) async {
    await seed();
    await pump(tester, '/');
    expect(find.text("Omar's birthday"), findsOneWidget);
    expect(find.text('This week'), findsOneWidget);
    expect(find.text('Later this month'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'internet');
    await tester.pumpAndSettle();
    expect(find.text('Pay internet bill'), findsOneWidget);
    expect(find.text("Mom's birthday"), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Arabic mirrors shell and FAB', (tester) async {
    await settings.set('language', 'ar');
    await pump(tester, '/', wholeApp: true);
    expect(
      Directionality.of(tester.element(find.byType(FloatingActionButton))),
      TextDirection.rtl,
    );
    expect(
      tester.getCenter(find.byType(FloatingActionButton)).dx,
      lessThan(195),
    );
    expect(tester.takeException(), isNull);
  });
  for (final language in ['en', 'ar']) {
    for (final dark in [false, true]) {
      for (final screen in [
        'home',
        'detail',
        'calendar',
        'editor',
        'settings',
      ]) {
        testWidgets('$screen $language ${dark ? 'dark' : 'light'} golden', (
          tester,
        ) async {
          await seed();
          await settings.set('language', language);
          await settings.set('theme', dark ? 'dark' : 'light');
          await pump(
            tester,
            screen == 'home'
                ? '/'
                : screen == 'detail'
                ? '/detail/mom'
                : '/$screen',
            wholeApp: ['home', 'calendar', 'settings'].contains(screen),
          );
          expect(tester.takeException(), isNull);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile(
              'goldens/$screen-$language-${dark ? 'dark' : 'light'}.png',
            ),
          );
          await tester.pumpWidget(const SizedBox.shrink());
        });
      }
    }
  }
  test('Arabic plurals cover all categories', () {
    final l = lookupAppLocalizations(const Locale('ar'));
    expect(l.daysLeft(0, '٠'), 'اليوم');
    expect(l.daysLeft(1, '١'), 'متبقي يوم واحد');
    expect(l.daysLeft(2, '٢'), 'متبقي يومان');
    expect(l.daysLeft(3, '٣'), 'متبقي ٣ أيام');
    expect(l.daysLeft(11, '١١'), 'متبقي ١١ يومًا');
    expect(l.daysLeft(100, '١٠٠'), 'متبقي ١٠٠ يوم');
  });
}
