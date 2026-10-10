import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/tokens.dart';
import '../../core/models.dart';
import '../../core/recurrence.dart';
import '../common.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool all;
  const HomeScreen({super.key, this.all = false});
  @override
  ConsumerState<HomeScreen> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeScreen> {
  String filter = 'all', query = '';
  bool searching = false;
  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(remindersProvider);
    final logs = ref.watch(logsProvider).value ?? [];
    final s = ref.watch(settingsProvider);
    final scheduler = ref.watch(schedulerProvider);
    final today = DateOnly.from(ref.read(repositoryProvider).clock.now());
    final done = logs
        .where((l) => l.status == 'done')
        .map((l) => l.key)
        .toSet();
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(repositoryProvider).markMissed();
        await scheduler.syncAlarms();
        if (mounted) setState(() {});
      },
      child: reminders.when(
        error: (e, st) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(context.t('error')),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (rows) {
          final visible = rows
              .where(
                (r) =>
                    (query.isEmpty ||
                        '${r.title} ${r.note}'.toLowerCase().contains(
                          query.toLowerCase(),
                        )) &&
                    (filter == 'all' ||
                        filter == 'birthdays' &&
                            r.type == ReminderType.birthday ||
                        filter == r.repeat.name),
              )
              .toList();
          final upcoming = [
            for (final r in visible)
              if (nextOccurrence(r, today, done) case final DateOnly d)
                (reminder: r, date: d),
          ]..sort((a, b) => a.date.compareTo(b.date));
          final hero = !widget.all && upcoming.isNotEmpty
              ? upcoming.first
              : null;
          final groups = <String, List<({Reminder reminder, DateOnly date})>>{};
          for (final item in upcoming.skip(hero == null ? 0 : 1)) {
            final endOfWeek = today.addDays(7);
            final key = item.date.compareTo(endOfWeek) <= 0
                ? 'thisWeek'
                : item.date.year == today.year && item.date.month == today.month
                ? 'laterMonth'
                : 'later';
            groups.putIfAbsent(key, () => []).add(item);
          }
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 90),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateText(
                            today,
                            s,
                            pattern: 'EEEE, d MMM',
                          ).toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.t(widget.all ? 'all' : 'comingUp'),
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    tooltip: context.t('search'),
                    onPressed: () => setState(() => searching = !searching),
                    icon: const Icon(Icons.search),
                  ),
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    tooltip: context.t('notifications'),
                    onPressed: () => context.go('/settings'),
                    icon: const Icon(Icons.notifications_none),
                  ),
                ],
              ),
              if (searching || widget.all) ...[
                const SizedBox(height: 16),
                TextField(
                  onChanged: (v) => setState(() => query = v),
                  decoration: InputDecoration(
                    hintText: context.t('search'),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ],
              ListenableBuilder(
                listenable: scheduler,
                builder: (context, _) =>
                    scheduler.notificationsAllowed && scheduler.exactAllowed
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.warning_amber,
                              color: Tokens.warning,
                            ),
                            title: Text(context.t('permissionBanner')),
                            onTap: () => context.go('/settings'),
                          ),
                        ),
                      ),
              ),
              if (hero != null) ...[
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => context.push('/detail/${hero.reminder.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Tokens.accent,
                      borderRadius: BorderRadius.circular(Tokens.hero),
                    ),
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.l
                                      .nextLabel(
                                        relativeText(
                                          hero.date,
                                          today,
                                          context.l,
                                          s,
                                        ),
                                      )
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(
                                    Tokens.chip,
                                  ),
                                ),
                                child: Text(
                                  context.t(hero.reminder.repeat.name),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      dateText(
                                        hero.date,
                                        s,
                                        pattern: 'MMM',
                                      ).toUpperCase(),
                                      style: const TextStyle(
                                        color: Tokens.yearly,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      numText(hero.date.day, s),
                                      style: const TextStyle(
                                        color: Tokens.ink,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hero.reminder.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      '${hero.reminder.knownYear == null ? '' : context.l.turns(numText(ageOn(hero.reminder, hero.date)!, s))} · ${dateText(hero.date, s, pattern: 'EEEE')}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Tokens.ink,
                                    minimumSize: const Size(44, 44),
                                  ),
                                  onPressed: () => wish(context, hero.reminder),
                                  child: Text(context.t('sendWish')),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(44, 44),
                                    side: const BorderSide(color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        Tokens.control,
                                      ),
                                    ),
                                  ),
                                  onPressed: () => snooze(
                                    context,
                                    ref,
                                    hero.reminder,
                                    hero.date,
                                  ),
                                  child: Text(context.t('snooze')),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final key in ['all', 'birthdays', 'monthly', 'weekly'])
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ChoiceChip(
                          selectedColor: Theme.of(context)
                              .colorScheme
                              .onSurface,
                          label: Text(
                            context.t(key),
                            style: TextStyle(
                              color: filter == key
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          selected: filter == key,
                          onSelected: (_) => setState(() => filter = key),
                        ),
                      ),
                  ],
                ),
              ),
              if (rows.isEmpty)
                const EmptyState()
              else if (visible.isEmpty)
                const EmptyState(noResults: true),
              if (widget.all) ...[
                const SizedBox(height: 14),
                for (final r in visible)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ReminderTile(r, nextOccurrence(r, today, done)),
                  ),
              ] else ...[
                for (final group in groups.entries) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 10),
                    child: Text(
                      context.t(group.key),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  for (final item in group.value)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Dismissible(
                        key: ValueKey('${item.reminder.id}|${item.date}'),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          await ref
                              .read(repositoryProvider)
                              .act(item.reminder.id, item.date, 'done');
                          return false;
                        },
                        background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Tokens.monthly,
                            borderRadius: BorderRadius.circular(Tokens.card),
                          ),
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                        child: ReminderTile(item.reminder, item.date),
                      ),
                    ),
                ],
                if (upcoming.isEmpty && visible.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(context.t('noUpcoming')),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
