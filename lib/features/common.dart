import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/formatting.dart';
export '../app/formatting.dart';

import 'package:share_plus/share_plus.dart';

import '../app/providers.dart';
import '../app/strings.dart';
import '../app/tokens.dart';
import '../core/models.dart';
import '../core/recurrence.dart' show ageParts;

Color reminderColor(Reminder r, bool dark) => switch (r.type) {
  ReminderType.birthday ||
  ReminderType.anniversary => dark ? Tokens.darkYearly : Tokens.yearly,
  ReminderType.bill => dark ? Tokens.darkMonthly : Tokens.monthly,
  ReminderType.other => switch (r.repeat) {
    RepeatMode.monthly => dark ? Tokens.darkMonthly : Tokens.monthly,
    RepeatMode.weekly => dark ? Tokens.darkWeekly : Tokens.weekly,
    _ => Tokens.daily,
  },
};
Color reminderTint(Reminder r, bool dark) => switch (r.type) {
  ReminderType.birthday ||
  ReminderType.anniversary => dark ? Tokens.darkYearlyTint : Tokens.yearlyTint,
  ReminderType.bill => dark ? Tokens.darkMonthlyTint : Tokens.monthlyTint,
  _ => dark ? Tokens.darkWeeklyTint : Tokens.weeklyTint,
};
IconData reminderIcon(Reminder r) => switch (r.type) {
  ReminderType.birthday => Icons.cake_outlined,
  ReminderType.anniversary => Icons.favorite_border,
  ReminderType.bill => Icons.credit_card_outlined,
  _ => Icons.repeat,
};
Future<void> wish(BuildContext context, Reminder r) async {
  final l = context.l;
  final message = switch (r.type) {
    ReminderType.birthday => l.wishBirthday(r.title),
    ReminderType.anniversary => l.wishAnniversary(r.title),
    _ => l.wishOther(r.title),
  };
  await SharePlus.instance.share(ShareParams(text: message));
}

Future<void> snooze(
  BuildContext context,
  WidgetRef ref,
  Reminder r,
  DateOnly date,
) async {
  final option = await showModalBottomSheet<int>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(context.t('oneHour')),
            leading: const Icon(Icons.snooze),
            onTap: () => Navigator.pop(ctx, 1),
          ),
          ListTile(
            title: Text(context.t('tomorrowTime')),
            leading: const Icon(Icons.wb_sunny_outlined),
            onTap: () => Navigator.pop(ctx, 2),
          ),
        ],
      ),
    ),
  );
  if (option == null) return;
  final now = ref.read(repositoryProvider).clock.now();
  final tomorrow = DateOnly.from(now).addDays(1);
  await ref
      .read(repositoryProvider)
      .act(
        r.id,
        date,
        'snoozed',
        until: option == 1
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

Future<void> deleteReminder(
  BuildContext context,
  WidgetRef ref,
  Reminder r,
) async {
  final yes = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(context.t('deleteTitle')),
      content: Text(context.t('deleteBody')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(context.t('cancel')),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(context.t('delete')),
        ),
      ],
    ),
  );
  if (yes != true || !context.mounted) return;
  final repo = ref.read(repositoryProvider);
  final records = (await repo.logs())
      .where((l) => l.reminderId == r.id)
      .toList();
  await repo.delete(r.id);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(context.t('deleted')),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: context.t('undo'),
        onPressed: () async {
          await repo.save(r, sync: false);
          for (final l in records) {
            await repo.act(
              r.id,
              l.date,
              l.status,
              until: l.snoozedUntil,
              sync: false,
              actedAt: l.actedAt,
            );
          }
          await repo.onChanged?.call();
        },
      ),
    ),
  );
}

class ReminderTile extends ConsumerWidget {
  final Reminder reminder;
  final DateOnly? date;
  const ReminderTile(this.reminder, this.date, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final color = reminderColor(reminder, dark);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(Tokens.card),
        onTap: () => context.push('/detail/${reminder.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: reminderTint(reminder, dark),
                  borderRadius: BorderRadius.circular(Tokens.control),
                ),
                child: Icon(reminderIcon(reminder), color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${context.t(reminder.repeat.name)} · ${reminder.repeat == RepeatMode.yearly || reminder.repeat == RepeatMode.once
                          ? dateText(reminder.anchor, s)
                          : reminder.repeat == RepeatMode.monthly
                          ? '${numText(reminder.dayOfMonth, s)} · ${timeText(reminder.alertMinutes, s)}'
                          : timeText(reminder.alertMinutes, s)}${reminder.type == ReminderType.birthday && reminder.knownYear != null ? ' · ${context.l.nowAge(numText(ageParts(reminder.anchor.inYear(reminder.knownYear!), DateOnly.from(ref.read(repositoryProvider).clock.now())).years, s))}' : ''}',
                      maxLines: 2,
                    ),
                    if (!reminder.active) Text(context.t('paused')),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (date != null)
                Text(
                  relativeText(
                    date!,
                    DateOnly.from(ref.read(repositoryProvider).clock.now()),
                    context.l,
                    s,
                  ),
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final bool noResults;
  const EmptyState({super.key, this.noResults = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 50),
    child: Column(
      children: [
        Icon(
          noResults ? Icons.search_off : Icons.notifications_none,
          size: 64,
          color: Tokens.accent,
        ),
        const SizedBox(height: 20),
        Text(
          context.t(noResults ? 'noResults' : 'emptyTitle'),
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        if (!noResults)
          Text(context.t('emptyBody'), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        if (!noResults)
          FilledButton.icon(
            onPressed: () => context.push('/editor'),
            icon: const Icon(Icons.add),
            label: Text(context.t('firstReminder')),
          ),
      ],
    ),
  );
}
