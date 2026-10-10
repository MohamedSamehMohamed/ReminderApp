import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @comingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get comingUp;

  /// No description provided for @nextUp.
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get nextUp;

  /// No description provided for @sendWish.
  ///
  /// In en, this message translates to:
  /// **'Send a wish'**
  String get sendWish;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snooze;

  /// No description provided for @birthdays.
  ///
  /// In en, this message translates to:
  /// **'Birthdays'**
  String get birthdays;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @once.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get once;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @laterMonth.
  ///
  /// In en, this message translates to:
  /// **'Later this month'**
  String get laterMonth;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search reminders'**
  String get search;

  /// No description provided for @newReminder.
  ///
  /// In en, this message translates to:
  /// **'New reminder'**
  String get newReminder;

  /// No description provided for @editReminder.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get editReminder;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @anniversary.
  ///
  /// In en, this message translates to:
  /// **'Anniversary'**
  String get anniversary;

  /// No description provided for @bill.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get bill;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @repeats.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get repeats;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @starts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get starts;

  /// No description provided for @dayMonth.
  ///
  /// In en, this message translates to:
  /// **'Day of month'**
  String get dayMonth;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @birthYear.
  ///
  /// In en, this message translates to:
  /// **'Birth year'**
  String get birthYear;

  /// No description provided for @originalYear.
  ///
  /// In en, this message translates to:
  /// **'Original year'**
  String get originalYear;

  /// No description provided for @optionalYear.
  ///
  /// In en, this message translates to:
  /// **'Optional · shows live age'**
  String get optionalYear;

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get remindMe;

  /// No description provided for @day0.
  ///
  /// In en, this message translates to:
  /// **'On the day'**
  String get day0;

  /// No description provided for @day1.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get day1;

  /// No description provided for @week1.
  ///
  /// In en, this message translates to:
  /// **'1 week before'**
  String get week1;

  /// No description provided for @month1.
  ///
  /// In en, this message translates to:
  /// **'1 month before'**
  String get month1;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Gift idea, phone number…'**
  String get noteHint;

  /// No description provided for @saveReminder.
  ///
  /// In en, this message translates to:
  /// **'Save reminder'**
  String get saveReminder;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete reminder?'**
  String get deleteTitle;

  /// No description provided for @deleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the reminder and its history.'**
  String get deleteBody;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Reminder deleted'**
  String get deleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to remember yet'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'Keep the people and moments that matter close.'**
  String get emptyBody;

  /// No description provided for @firstReminder.
  ///
  /// In en, this message translates to:
  /// **'Add your first reminder'**
  String get firstReminder;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No reminders match your search'**
  String get noResults;

  /// No description provided for @noDay.
  ///
  /// In en, this message translates to:
  /// **'No reminders on this day'**
  String get noDay;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @pastOccurrences.
  ///
  /// In en, this message translates to:
  /// **'Past occurrences'**
  String get pastOccurrences;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'Your history will appear here'**
  String get noHistory;

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @snoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get snoozed;

  /// No description provided for @ageNow.
  ///
  /// In en, this message translates to:
  /// **'Age right now'**
  String get ageNow;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @totalDays.
  ///
  /// In en, this message translates to:
  /// **'Total days lived'**
  String get totalDays;

  /// No description provided for @secondsLived.
  ///
  /// In en, this message translates to:
  /// **'Seconds lived'**
  String get secondsLived;

  /// No description provided for @countdown.
  ///
  /// In en, this message translates to:
  /// **'Until the next occurrence'**
  String get countdown;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'In 1 hour'**
  String get oneHour;

  /// No description provided for @tomorrowTime.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow at the alert time'**
  String get tomorrowTime;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @numbers.
  ///
  /// In en, this message translates to:
  /// **'Number style'**
  String get numbers;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @weekStart.
  ///
  /// In en, this message translates to:
  /// **'First day of week'**
  String get weekStart;

  /// No description provided for @defaults.
  ///
  /// In en, this message translates to:
  /// **'Defaults'**
  String get defaults;

  /// No description provided for @defaultTime.
  ///
  /// In en, this message translates to:
  /// **'Default alert time'**
  String get defaultTime;

  /// No description provided for @defaultLeads.
  ///
  /// In en, this message translates to:
  /// **'Default lead alerts'**
  String get defaultLeads;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @exactAlarms.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms'**
  String get exactAlarms;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery optimization'**
  String get battery;

  /// No description provided for @allowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get allowed;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @restricted.
  ///
  /// In en, this message translates to:
  /// **'Restricted'**
  String get restricted;

  /// No description provided for @fix.
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get fix;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backup;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get import;

  /// No description provided for @merge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace all'**
  String get replace;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get importTitle;

  /// No description provided for @importBody.
  ///
  /// In en, this message translates to:
  /// **'Merge with existing reminders or replace all local data?'**
  String get importBody;

  /// No description provided for @imported.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get imported;

  /// No description provided for @exported.
  ///
  /// In en, this message translates to:
  /// **'Backup exported'**
  String get exported;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error;

  /// No description provided for @invalidTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a title with 1–80 characters'**
  String get invalidTitle;

  /// No description provided for @invalidDays.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one weekday'**
  String get invalidDays;

  /// No description provided for @invalidLeads.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one alert'**
  String get invalidLeads;

  /// No description provided for @invalidYear.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid year, not in the future'**
  String get invalidYear;

  /// No description provided for @invalidNote.
  ///
  /// In en, this message translates to:
  /// **'Keep the note within 500 characters'**
  String get invalidNote;

  /// No description provided for @permissionBanner.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications and exact alarms for reliable reminders.'**
  String get permissionBanner;

  /// No description provided for @onboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Never miss a meaningful moment'**
  String get onboardTitle;

  /// No description provided for @onboardBody.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications and exact alarms so Reminders can alert you at the time you choose, even when your phone is asleep.'**
  String get onboardBody;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable reminders'**
  String get enable;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'Offline. Private. Made for your moments.'**
  String get about;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @noUpcoming.
  ///
  /// In en, this message translates to:
  /// **'No upcoming occurrence'**
  String get noUpcoming;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day at the chosen time'**
  String get everyDay;

  /// No description provided for @onceSummary.
  ///
  /// In en, this message translates to:
  /// **'A one-time reminder'**
  String get onceSummary;

  /// No description provided for @monthClamp.
  ///
  /// In en, this message translates to:
  /// **'Last day in shorter months'**
  String get monthClamp;

  /// No description provided for @weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get weekdays;

  /// No description provided for @turns.
  ///
  /// In en, this message translates to:
  /// **'Turns {number}'**
  String turns(String number);

  /// No description provided for @nowAge.
  ///
  /// In en, this message translates to:
  /// **'Now {number}'**
  String nowAge(String number);

  /// No description provided for @anniversaryCount.
  ///
  /// In en, this message translates to:
  /// **'{number} years together'**
  String anniversaryCount(String number);

  /// No description provided for @yearSummary.
  ///
  /// In en, this message translates to:
  /// **'Every year on {date}'**
  String yearSummary(String date);

  /// No description provided for @monthSummary.
  ///
  /// In en, this message translates to:
  /// **'On day {number} of every month'**
  String monthSummary(String number);

  /// No description provided for @weekSummary.
  ///
  /// In en, this message translates to:
  /// **'Every {days}'**
  String weekSummary(String days);

  /// No description provided for @wishBirthday.
  ///
  /// In en, this message translates to:
  /// **'Happy birthday, {title}!'**
  String wishBirthday(String title);

  /// No description provided for @wishAnniversary.
  ///
  /// In en, this message translates to:
  /// **'Happy anniversary, {title}!'**
  String wishAnniversary(String title);

  /// No description provided for @wishOther.
  ///
  /// In en, this message translates to:
  /// **'Thinking of you: {title}'**
  String wishOther(String title);

  /// No description provided for @relativeDays.
  ///
  /// In en, this message translates to:
  /// **'{number} d'**
  String relativeDays(String number);

  /// No description provided for @nextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next up · {date}'**
  String nextLabel(String date);

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Today} =1{1 day left} other{{number} days left}}'**
  String daysLeft(int count, String number);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
