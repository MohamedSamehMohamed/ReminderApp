import 'package:intl/intl.dart';

import '../core/models.dart';
import '../core/recurrence.dart' hide summary;
import '../core/recurrence.dart' as core;
import '../l10n/app_localizations.dart';
import 'settings.dart';

String numText(Object n, AppSettings settings) =>
    formatNumber(n, arabic: settings.arabicDigits);
String dateText(DateOnly d, AppSettings settings, {String pattern = 'd MMM'}) =>
    formatNumber(
      DateFormat(pattern, settings.arabic ? 'ar' : 'en')
          .format(d.date)
          .replaceAllMapped(
            RegExp('[٠-٩]'),
            (m) => '٠١٢٣٤٥٦٧٨٩'.indexOf(m[0]!).toString(),
          ),
      arabic: settings.arabicDigits,
    );
String timeText(int minutes, AppSettings settings) => formatNumber(
  DateFormat('h:mm a', settings.arabic ? 'ar' : 'en')
      .format(DateTime(2000, 1, 1, minutes ~/ 60, minutes % 60))
      .replaceAllMapped(
        RegExp('[٠-٩]'),
        (m) => '٠١٢٣٤٥٦٧٨٩'.indexOf(m[0]!).toString(),
      ),
  arabic: settings.arabicDigits,
);
String relativeText(
  DateOnly d,
  DateOnly today,
  AppLocalizations l,
  AppSettings s,
) => core.relativeLabel(
  d,
  today,
  todayLabel: l.today,
  tomorrowLabel: l.tomorrow,
  weekdayLabel: (d) => dateText(d, s, pattern: 'EEE'),
  daysLabel: (n) => l.relativeDays(numText(n, s)),
);
String summary(Reminder r, AppLocalizations l, AppSettings s) => core.summary(
  r,
  once: (d, _) => '${l.onceSummary} · ${dateText(d, s, pattern: "d MMM y")}',
  daily: l.everyDay,
  weekly: (days) => l.weekSummary(
    days
        .map(
          (n) =>
              dateText(DateOnly(2026, 10, 5).addDays(n - 1), s, pattern: 'EEE'),
        )
        .join(s.arabic ? '، ' : ', '),
  ),
  monthly: (day, clamp) =>
      '${l.monthSummary(numText(day, s))}${clamp ? " · ${l.monthClamp}" : ""}',
  yearly: (d) => l.yearSummary(dateText(d, s, pattern: 'd MMMM')),
);
