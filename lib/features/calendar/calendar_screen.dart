import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/strings.dart';
import '../../app/tokens.dart';
import '../../core/models.dart';
import '../../core/recurrence.dart';
import '../common.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});
  @override
  ConsumerState<CalendarScreen> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<CalendarScreen> {
  Color repeatColor(RepeatMode mode, bool dark) => switch (mode) {
    RepeatMode.yearly => dark ? Tokens.darkYearly : Tokens.yearly,
    RepeatMode.monthly => dark ? Tokens.darkMonthly : Tokens.monthly,
    RepeatMode.weekly => dark ? Tokens.darkWeekly : Tokens.weekly,
    _ => Tokens.daily,
  };
  late DateOnly month, selected;
  @override
  void initState() {
    super.initState();
    selected = DateOnly.from(ref.read(repositoryProvider).clock.now());
    month = DateOnly(selected.year, selected.month, 1);
  }

  void changeMonth(int n) => setState(() {
    month = month.addMonths(n);
    selected = month;
  });
  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider);
    final rows = ref.watch(remindersProvider).value ?? [];
    final dark = Theme.of(context).brightness == Brightness.dark;
    final today = DateOnly.from(ref.read(repositoryProvider).clock.now());
    final start = month.addDays(-((month.weekday - s.weekStart + 7) % 7));
    final items = <DateOnly, List<Reminder>>{};
    for (final r in rows.where((r) => r.active)) {
      for (final d in occurrences(r, start, start.addDays(41))) {
        items.putIfAbsent(d, () => []).add(r);
      }
    }
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 90),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                dateText(month, s, pattern: 'MMMM y'),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            IconButton(
              onPressed: () => changeMonth(-1),
              icon: const Icon(Icons.chevron_left),
              tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
            ),
            IconButton(
              onPressed: () => changeMonth(1),
              icon: const Icon(Icons.chevron_right),
              tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
            ),
          ],
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onHorizontalDragEnd: (d) => changeMonth(
            ((d.primaryVelocity ?? 0) < 0 ? 1 : -1) *
                (Directionality.of(context) == TextDirection.rtl ? -1 : 1),
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < 7; i++)
                        Expanded(
                          child: Center(
                            child: Text(
                              dateText(start.addDays(i), s, pattern: 'EEEEE'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: 42,
                    itemBuilder: (ctx, i) {
                      final d = start.addDays(i);
                      final events = items[d] ?? [];
                      return InkWell(
                        onTap: () => setState(() => selected = d),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: d == selected
                                ? Tokens.accent
                                : d == today
                                ? (dark
                                      ? Tokens.darkWeeklyTint
                                      : Tokens.weeklyTint)
                                : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                numText(d.day, s),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: d == selected
                                      ? Colors.white
                                      : d.month != month.month
                                      ? Theme.of(context).disabledColor
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (final r in events.take(3))
                                    Container(
                                      width: 4,
                                      height: 4,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: d == selected
                                            ? Colors.white
                                            : repeatColor(r.repeat, dark),
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
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            for (final mode in [
              RepeatMode.yearly,
              RepeatMode.monthly,
              RepeatMode.weekly,
              RepeatMode.daily,
            ])
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: reminderColor(
                        Reminder(
                          id: '',
                          title: '',
                          anchor: month,
                          repeat: mode,
                          type: mode == RepeatMode.yearly
                              ? ReminderType.birthday
                              : ReminderType.other,
                        ),
                        dark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(context.t(mode.name)),
                ],
              ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          dateText(selected, s, pattern: 'EEEE, d MMMM'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        if ((items[selected] ?? []).isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Text(context.t('noDay'))),
          ),
        for (final r in items[selected] ?? <Reminder>[])
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ReminderTile(r, selected),
          ),
      ],
    );
  }
}
