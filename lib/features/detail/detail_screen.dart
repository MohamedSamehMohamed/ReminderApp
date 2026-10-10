import 'dart:async';

import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/navigation.dart';
import '../../app/strings.dart';
import '../../app/tokens.dart';
import '../../core/models.dart';
import '../../core/recurrence.dart' hide summary;
import '../common.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String id;
  const DetailScreen(this.id, {super.key});
  @override
  ConsumerState<DetailScreen> createState() => _DetailState();
}

class _DetailState extends ConsumerState<DetailScreen>
    with WidgetsBindingObserver, RouteAware {
  Timer? timer;
  bool resumed = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startTicking();
  }

  void startTicking() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && resumed && (ModalRoute.of(context)?.isCurrent ?? false)) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) routeObserver.subscribe(this, route);
  }

  @override
  void didPushNext() {
    timer?.cancel();
  }

  @override
  void didPopNext() {
    if (resumed) startTicking();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    resumed = state == AppLifecycleState.resumed;
    if (resumed && (ModalRoute.of(context)?.isCurrent ?? false)) {
      startTicking();
    } else {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rows = ref.watch(remindersProvider).value ?? [];
    Reminder? r;
    for (final item in rows) {
      if (item.id == widget.id) r = item;
    }
    if (r == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final reminder = r;
    final s = ref.watch(settingsProvider);
    final logs =
        (ref.watch(logsProvider).value ?? [])
            .where((l) => l.reminderId == r!.id)
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    final now = ref.read(repositoryProvider).clock.now();
    final today = DateOnly.from(now);
    final next = nextOccurrence(
      r,
      today,
      logs.where((l) => l.status == 'done').map((l) => l.key).toSet(),
    );
    final delta = next == null || next == today
        ? Duration.zero
        : next.date.difference(now);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('appName')),
        actions: [
          IconButton(
            tooltip: context.t('editReminder'),
            onPressed: () => context.push('/editor/${reminder.id}'),
            icon: const Icon(Icons.edit_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (_) async {
              await deleteReminder(context, ref, reminder);
              if (context.mounted &&
                  !(await ref.read(repositoryProvider).reminders()).any(
                    (x) => x.id == reminder.id,
                  )) {
                if (context.mounted) context.pop();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'delete', child: Text(context.t('delete'))),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  reminder.type == ReminderType.birthday ||
                      reminder.type == ReminderType.anniversary
                  ? Tokens.detailHeader
                  : reminderColor(reminder, dark),
              borderRadius: BorderRadius.circular(Tokens.hero),
            ),
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(reminderIcon(reminder), color: Colors.white, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    reminder.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (next != null)
                    Text(
                      '${dateText(next, s, pattern: 'd MMMM')} · ${reminder.knownYear == null ? context.t(reminder.repeat.name) : context.l.turns(numText(ageOn(reminder, next)!, s))}',
                    ),
                  const SizedBox(height: 18),
                  if (next == today)
                    Text(
                      context.t('today'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  else if (next == null)
                    Text(context.t('noUpcoming'))
                  else
                    Row(
                      children: [
                        for (final part in [
                          (delta.inDays, 'days'),
                          (delta.inHours % 24, 'hours'),
                          (delta.inMinutes % 60, 'minutes'),
                          (delta.inSeconds % 60, 'seconds'),
                        ])
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  numText(part.$1, s),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  context.t(part.$2),
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (reminder.type == ReminderType.birthday &&
              reminder.knownYear != null) ...[
            const SizedBox(height: 16),
            Builder(
              builder: (ctx) {
                final birth = reminder.anchor.inYear(reminder.knownYear!);
                final age = ageParts(birth, today);
                final lived = now.difference(birth.date);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                context.t('ageNow'),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            const Icon(
                              Icons.circle,
                              size: 6,
                              color: Tokens.monthly,
                            ),
                            const SizedBox(width: 5),
                            Text(context.t('live')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            for (final p in [
                              (age.years, 'years'),
                              (age.months, 'months'),
                              (age.days, 'days'),
                            ])
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsetsDirectional.only(
                                    end: 6,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: dark
                                        ? Tokens.raised
                                        : Tokens.background,
                                    borderRadius: BorderRadius.circular(
                                      Tokens.control,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        numText(p.$1, s),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                      Text(context.t(p.$2)),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(child: Text(context.t('totalDays'))),
                            Text(
                              numText(birth.daysUntil(today), s),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: Text(context.t('secondsLived'))),
                            Flexible(
                              child: Text(
                                numText(
                                  lived.inSeconds < 0 ? 0 : lived.inSeconds,
                                  s,
                                ),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.repeat),
                  title: Text(context.t('repeats')),
                  subtitle: Text(summary(reminder, context.l, s)),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.notifications_none),
                  title: Text(timeText(reminder.alertMinutes, s)),
                  subtitle: Text(
                    [
                      for (var i = 0; i < 4; i++)
                        if (reminder.leads & (1 << i) != 0)
                          context.t(['day0', 'day1', 'week1', 'month1'][i]),
                    ].join(' · '),
                  ),
                ),
              ],
            ),
          ),
          if (reminder.note.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('note'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(reminder.note),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => wish(context, reminder),
                  child: Text(context.t('sendWish')),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: next == null
                      ? null
                      : () => snooze(context, ref, reminder, next),
                  child: Text(context.t('snooze')),
                ),
              ),
            ],
          ),
          if (next != null)
            TextButton.icon(
              onPressed: () =>
                  ref.read(repositoryProvider).act(reminder.id, next, 'done'),
              icon: const Icon(Icons.check),
              label: Text(context.t('done')),
            ),
          const SizedBox(height: 20),
          Text(
            context.t('pastOccurrences'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (logs.isEmpty) Text(context.t('noHistory')),
          for (final log in logs)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(dateText(log.date, s, pattern: 'd MMM y')),
              trailing: Text(context.t(log.status)),
              leading: Icon(
                log.status == 'done'
                    ? Icons.check_circle_outline
                    : Icons.history,
              ),
            ),
        ],
      ),
    );
  }
}
