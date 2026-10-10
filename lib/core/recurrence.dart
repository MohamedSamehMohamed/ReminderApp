import 'models.dart';

List<DateOnly> occurrences(Reminder r, DateOnly from, DateOnly to) {
  if (from.compareTo(to) > 0) return [];
  final result = <DateOnly>[];
  for (var d = from; d.compareTo(to) <= 0; d = d.addDays(1)) {
    final start = r.repeat == RepeatMode.monthly
        ? DateOnly(r.anchor.year, r.anchor.month, 1)
        : r.anchor;
    if (r.repeat != RepeatMode.yearly && d.compareTo(start) < 0) continue;
    final matches = switch (r.repeat) {
      RepeatMode.once => d == r.anchor,
      RepeatMode.daily => true,
      RepeatMode.weekly => r.weekdays & (1 << (d.weekday - 1)) != 0,
      RepeatMode.monthly =>
        d.day ==
            (r.dayOfMonth < DateTime.utc(d.year, d.month + 1, 0).day
                ? r.dayOfMonth
                : DateTime.utc(d.year, d.month + 1, 0).day),
      RepeatMode.yearly =>
        d == r.anchor.inYear(d.year) &&
            (r.knownYear == null || d.year >= r.knownYear!),
    };
    if (matches) result.add(d);
  }
  return result;
}

class LeadAlert {
  final DateOnly occurrence;
  final String lead;
  final DateTime fireAt;
  const LeadAlert(this.occurrence, this.lead, this.fireAt);
}

List<LeadAlert> leadAlerts(Reminder r, DateOnly occurrence, DateTime now) {
  final dates = [
    occurrence,
    occurrence.addDays(-1),
    occurrence.addDays(-7),
    occurrence.addMonths(-1),
  ];
  final result = <LeadAlert>[];
  final seen = <DateTime>{};
  for (var i = 0; i < 4; i++) {
    if (r.leads & (1 << i) == 0) continue;
    final d = dates[i];
    final at = DateTime(
      d.year,
      d.month,
      d.day,
      r.alertMinutes ~/ 60,
      r.alertMinutes % 60,
    );
    if (!at.isBefore(now) && seen.add(at)) {
      result.add(
        LeadAlert(occurrence, ['day0', 'day1', 'week1', 'month1'][i], at),
      );
    }
  }
  return result;
}

int? ageOn(Reminder r, DateOnly d) =>
    r.knownYear == null ? null : d.year - r.knownYear!;
({int years, int months, int days}) ageParts(DateOnly birth, DateOnly today) {
  if (today.compareTo(birth) < 0) return (years: 0, months: 0, days: 0);
  var years = today.year - birth.year;
  if (birth.inYear(birth.year + years).compareTo(today) > 0) years--;
  final anniversary = birth.inYear(birth.year + years);
  var months = 0;
  while (months < 11 &&
      anniversary.addMonths(months + 1).compareTo(today) <= 0) {
    months++;
  }
  return (
    years: years,
    months: months,
    days: anniversary.addMonths(months).daysUntil(today),
  );
}

String formatNumber(Object n, {bool arabic = false}) {
  final s = n.toString();
  if (!arabic) return s;
  return s.replaceAllMapped(
    RegExp('[0-9]'),
    (m) => '٠١٢٣٤٥٦٧٨٩'[int.parse(m[0]!)],
  );
}

DateOnly? nextOccurrence(Reminder r, DateOnly today, Set<String> done) {
  if (!r.active) return null;
  for (final d in occurrences(r, today, today.addDays(1461))) {
    if (!done.contains('${r.id}|$d')) return d;
  }
  return null;
}

String relativeLabel(
  DateOnly d,
  DateOnly today, {
  required String todayLabel,
  required String tomorrowLabel,
  required String Function(DateOnly) weekdayLabel,
  required String Function(int) daysLabel,
}) {
  final days = today.daysUntil(d);
  if (days == 0) return todayLabel;
  if (days == 1) return tomorrowLabel;
  if (days >= 2 && days < 7) return weekdayLabel(d);
  return daysLabel(days);
}

String summary(
  Reminder r, {
  required String Function(DateOnly, bool) once,
  required String daily,
  required String Function(List<int>) weekly,
  required String Function(int, bool) monthly,
  required String Function(DateOnly) yearly,
}) => switch (r.repeat) {
  RepeatMode.once => once(r.anchor, true),
  RepeatMode.daily => daily,
  RepeatMode.weekly => weekly([
    for (var i = 0; i < 7; i++)
      if (r.weekdays & (1 << i) != 0) i + 1,
  ]),
  RepeatMode.monthly => monthly(r.dayOfMonth, r.dayOfMonth > 28),
  RepeatMode.yearly => yearly(r.anchor),
};
