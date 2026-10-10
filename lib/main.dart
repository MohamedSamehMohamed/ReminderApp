import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'app/providers.dart';
import 'app/navigation.dart';
import 'app/settings.dart';
import 'app/strings.dart';
import 'app/tokens.dart';
import 'data/database.dart';
import 'data/repository.dart';
import 'features/home/home_screen.dart';
import 'features/calendar/calendar_screen.dart';
import 'features/editor/editor_screen.dart';
import 'features/detail/detail_screen.dart';
import 'features/settings/settings_screen.dart';
import 'l10n/app_localizations.dart';
import 'notifications/scheduler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = AppSettings(await SharedPreferences.getInstance());
  final repo = Repository(AppDatabase());
  final scheduler = AlarmScheduler(repo, settings);
  await scheduler.initialize();
  repo.onChanged = scheduler.syncAlarms;
  await Workmanager().initialize(workDispatcher);
  await Workmanager().registerPeriodicTask(
    'daily-alarm-sync',
    'syncAlarms',
    frequency: const Duration(days: 1),
  );
  await repo.markMissed();
  await scheduler.syncAlarms();
  runApp(
    ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(repo),
        settingsProvider.overrideWithValue(settings),
        schedulerProvider.overrideWithValue(scheduler),
      ],
      child: const RemindersApp(),
    ),
  );
}

class RemindersApp extends ConsumerStatefulWidget {
  const RemindersApp({super.key});
  @override
  ConsumerState<RemindersApp> createState() => _AppState();
}

class _AppState extends ConsumerState<RemindersApp>
    with WidgetsBindingObserver {
  late final GoRouter router;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    router = GoRouter(
      observers: [routeObserver],
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppShell(state.uri.path, child),
          routes: [
            GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
            GoRoute(
              path: '/calendar',
              builder: (_, _) => const CalendarScreen(),
            ),
            GoRoute(
              path: '/all',
              builder: (_, _) => const HomeScreen(all: true),
            ),
            GoRoute(
              path: '/settings',
              builder: (_, _) => const SettingsScreen(),
            ),
          ],
        ),
        GoRoute(path: '/editor', builder: (_, _) => const EditorScreen()),
        GoRoute(
          path: '/editor/:id',
          builder: (_, s) => EditorScreen(id: s.pathParameters['id']),
        ),
        GoRoute(
          path: '/detail/:id',
          builder: (_, s) => DetailScreen(s.pathParameters['id']!),
        ),
      ],
    );
    final scheduler = ref.read(schedulerProvider);
    scheduler.onOpen = (payload) {
      final id = payload.split('|').first;
      router.push('/detail/$id');
    };
    if (scheduler.initialPayload != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => scheduler.onOpen!(scheduler.initialPayload!),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(logsProvider);
      ref.invalidate(remindersProvider);
      ref.read(schedulerProvider).syncAlarms();
      ref.read(repositoryProvider).markMissed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider);
    return ListenableBuilder(
      listenable: s,
      builder: (context, _) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => context.t('appName'),
        theme: Tokens.theme(false, s.arabic),
        darkTheme: Tokens.theme(true, s.arabic),
        themeMode: s.theme,
        locale: Locale(s.arabic ? 'ar' : 'en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  final String path;
  final Widget child;
  const AppShell(this.path, this.child, {super.key});
  @override
  ConsumerState<AppShell> createState() => _ShellState();
}

class _ShellState extends ConsumerState<AppShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final settings = ref.read(settingsProvider);
      if (settings.onboarded) return;
      final yes = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(
            Icons.notifications_active_outlined,
            size: 40,
            color: Tokens.accent,
          ),
          title: Text(ctx.t('onboardTitle')),
          content: Text(ctx.t('onboardBody')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(ctx.t('notNow')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(ctx.t('enable')),
            ),
          ],
        ),
      );
      await settings.set('onboarded', true);
      if (yes == true) await ref.read(schedulerProvider).requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    const paths = ['/', '/calendar', '/all', '/settings'];
    return Scaffold(
      body: SafeArea(child: widget.child),
      floatingActionButton: widget.path == '/' || widget.path == '/all'
          ? SizedBox(
              width: Tokens.fab,
              height: Tokens.fab,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.onSurface,
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                tooltip: context.t('newReminder'),
                onPressed: () => context.push('/editor'),
                child: const Icon(Icons.add, size: 32),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: paths.indexOf(widget.path).clamp(0, 3),
        onDestinationSelected: (i) => context.go(paths[i]),
        destinations: [
          for (final item in [
            ('home', Icons.home_outlined),
            ('calendar', Icons.calendar_today_outlined),
            ('all', Icons.format_list_bulleted),
            ('settings', Icons.settings_outlined),
          ])
            NavigationDestination(
              icon: Icon(item.$2),
              label: context.t(item.$1),
            ),
        ],
      ),
    );
  }
}
