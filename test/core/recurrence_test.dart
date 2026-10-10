import 'package:flutter_test/flutter_test.dart';
import 'package:reminders/core/models.dart';
import 'package:reminders/core/recurrence.dart';
import 'package:reminders/notifications/plan.dart';

void main() {
  test('Localized summary and relative labels use pure callbacks', () {
    final base = const Reminder(
      id: 'a',
      title: 'a',
      anchor: DateOnly(2026, 1, 1),
    );
    String label(DateOnly d) => relativeLabel(
      d,
      const DateOnly(2026, 1, 1),
      todayLabel: 'Today',
      tomorrowLabel: 'Tomorrow',
      weekdayLabel: (_) => 'Weekday',
      daysLabel: (n) => '$n d',
    );
    expect(label(base.anchor), 'Today');
    expect(label(base.anchor.addDays(1)), 'Tomorrow');
    expect(label(base.anchor.addDays(2)), 'Weekday');
    expect(label(base.anchor.addDays(7)), '7 d');
    for (final mode in RepeatMode.values) {
      final r = Reminder(
        id: 'a',
        title: 'a',
        anchor: base.anchor,
        repeat: mode,
        dayOfMonth: 31,
        weekdays: 9,
      );
      expect(
        summary(
          r,
          once: (d, _) => 'Once $d',
          daily: 'Daily',
          weekly: (days) => 'Weekly $days',
          monthly: (day, clamp) => 'Monthly $day $clamp',
          yearly: (d) => 'Yearly $d',
        ),
        startsWith('${mode.name[0].toUpperCase()}${mode.name.substring(1)}'),
      );
    }
  });
  test('Clock, date identity, strict parsing and invalid fields', () {
    expect(const SystemClock().now().year, greaterThan(2020));
    expect(
      {const DateOnly(2026, 1, 1), DateOnly.parse('2026-01-01')}.length,
      1,
    );
    expect(() => DateOnly.parse('2026-02-31'), throwsFormatException);
    expect(() => DateOnly.parse('bad'), throwsFormatException);
    expect(
      Reminder(
        id: 'a',
        title: 'a',
        anchor: const DateOnly(2026, 1, 1),
        knownYear: 0,
        alertMinutes: -1,
        dayOfMonth: 32,
        note: 'a' * 501,
      ).validate(),
      containsAll(['year', 'time', 'day', 'note']),
    );
    expect(
      nextOccurrence(
        const Reminder(
          id: 'a',
          title: 'a',
          anchor: DateOnly(2026, 1, 1),
          active: false,
        ),
        const DateOnly(2026, 1, 1),
        {},
      ),
      isNull,
    );
    final log = OccurrenceLog('a', const DateOnly(2026, 1, 1), 'done', 'now');
    expect(OccurrenceLog.fromJson(log.toJson()).key, log.key);
  });
  Reminder r(
    RepeatMode mode, {
    DateOnly anchor = const DateOnly(2026, 1, 1),
    int day = 31,
    int weekdays = 9,
    int leads = 15,
  }) => Reminder(
    id: 'a',
    title: 'Test',
    anchor: anchor,
    repeat: mode,
    dayOfMonth: day,
    weekdays: weekdays,
    leads: leads,
  );
  test('Monthly 31 clamps every month', () {
    expect(
      occurrences(
        r(RepeatMode.monthly),
        const DateOnly(2026, 1, 1),
        const DateOnly(2026, 12, 31),
      ).map((d) => d.day),
      [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
    );
  });
  test('Leap birthday clamps to February 28', () {
    expect(
      occurrences(
        r(RepeatMode.yearly, anchor: const DateOnly(2004, 2, 29)),
        const DateOnly(2027, 1, 1),
        const DateOnly(2028, 12, 31),
      ),
      [const DateOnly(2027, 2, 28), const DateOnly(2028, 2, 29)],
    );
  });
  test('Weekly starts on Thursday after Wednesday anchor', () {
    expect(
      occurrences(
        r(RepeatMode.weekly, anchor: const DateOnly(2026, 10, 7)),
        const DateOnly(2026, 10, 1),
        const DateOnly(2026, 10, 12),
      ),
      [const DateOnly(2026, 10, 8), const DateOnly(2026, 10, 12)],
    );
  });
  test('Month lead clamps March 31', () {
    for (final y in [2027, 2028]) {
      expect(
        leadAlerts(
          r(RepeatMode.yearly, leads: 8),
          DateOnly(y, 3, 31),
          DateTime(y, 1, 1),
        ).single.fireAt,
        DateTime(y, 2, y == 2027 ? 28 : 29, 9),
      );
    }
  });
  test('Past alert today drops but occurrence stays', () {
    final rem = r(RepeatMode.daily, leads: 1);
    expect(
      leadAlerts(rem, const DateOnly(2026, 10, 10), DateTime(2026, 10, 10, 10)),
      isEmpty,
    );
    expect(
      nextOccurrence(rem, const DateOnly(2026, 10, 10), {}),
      const DateOnly(2026, 10, 10),
    );
  });
  test('Live age edge cases', () {
    expect(
      ageParts(const DateOnly(1968, 10, 24), const DateOnly(2026, 10, 10)),
      (years: 57, months: 11, days: 16),
    );
    expect(ageParts(const DateOnly(2000, 1, 31), const DateOnly(2000, 3, 1)), (
      years: 0,
      months: 1,
      days: 1,
    ));
    expect(ageParts(const DateOnly(2004, 2, 29), const DateOnly(2025, 2, 28)), (
      years: 21,
      months: 0,
      days: 0,
    ));
    expect(ageParts(const DateOnly(2030, 1, 1), const DateOnly(2026, 1, 1)), (
      years: 0,
      months: 0,
      days: 0,
    ));
  });
  test('Once, daily boundaries and done exclusion', () {
    expect(
      occurrences(
        r(RepeatMode.once),
        const DateOnly(2025, 1, 1),
        const DateOnly(2025, 12, 31),
      ),
      isEmpty,
    );
    expect(
      occurrences(
        r(RepeatMode.daily),
        const DateOnly(2025, 12, 30),
        const DateOnly(2026, 1, 2),
      ).length,
      2,
    );
    expect(
      nextOccurrence(r(RepeatMode.once), const DateOnly(2026, 1, 1), {
        'a|2026-01-01',
      }),
      isNull,
    );
    expect(
      occurrences(
        r(RepeatMode.daily),
        const DateOnly(2026, 2, 1),
        const DateOnly(2026, 1, 1),
      ),
      isEmpty,
    );
  });
  test('Numbers and UUID', () {
    expect(formatNumber('123.45', arabic: true), '١٢٣.٤٥');
    expect(formatNumber(123), '123');
    expect(
      newId(),
      matches(
        RegExp(
          r'^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}$',
        ),
      ),
    );
  });
  test('Alarm window cap, snooze and done', () {
    final now = DateTime(2026, 10, 10);
    final reminders = List.generate(
      20,
      (i) => Reminder(
        id: '$i',
        title: 'R$i',
        anchor: const DateOnly(2026, 1, 1),
        repeat: RepeatMode.daily,
      ),
    );
    expect(planAlarms(reminders, [], now).length, 400);
    final rem = reminders.first;
    final logs = [
      OccurrenceLog(rem.id, const DateOnly(2026, 10, 10), 'done', ''),
      OccurrenceLog(
        rem.id,
        const DateOnly(2026, 10, 11),
        'snoozed',
        '',
        DateTime(2026, 10, 12, 10),
      ),
    ];
    final plans = planAlarms([rem], logs, now);
    expect(plans.any((a) => a.date == const DateOnly(2026, 10, 10)), false);
    expect(
      plans.where((a) => a.date == const DateOnly(2026, 10, 11)).single.lead,
      'snooze',
    );
    expect(
      plans.every((a) => !a.fireAt.isAfter(now.add(const Duration(days: 60)))),
      true,
    );
  });
  test('Alarm diff is idempotent and updates content', () {
    final plans = planAlarms([r(RepeatMode.once)], [], DateTime(2026, 1, 1));
    final old = plans
        .map((a) => AlarmSnapshot(a.id, '${a.fingerprint}|zone'))
        .toList();
    expect(diffAlarms(old, plans, 'zone').schedule, isEmpty);
    expect(diffAlarms(old, plans, 'changed').schedule.length, plans.length);
    expect(diffAlarms(old, [], 'zone').cancel.length, plans.length);
  });
  test('Reminder validation', () {
    expect(r(RepeatMode.weekly, weekdays: 0).validate(), contains('weekdays'));
    expect(r(RepeatMode.once, leads: 0).validate(), contains('leads'));
    expect(
      Reminder(
        id: '',
        title: '',
        anchor: const DateOnly(2026, 2, 31),
      ).validate(),
      containsAll(['title', 'date']),
    );
  });
}
