# Reminders App — Build Handover Spec

Oct 10, 2026 · Mohamed

## Overview

**Reminders** is an offline-first Android app that reliably notifies the user about birthdays, anniversaries, bills and any event that repeats daily, weekly, monthly or yearly. Its one job is to never miss a notification, including after a reboot, in Doze mode, or when the phone has been idle for days.

This doc is a complete handover: together with the screen designs in `design/`, a developer or AI model should be able to build v1 without further questions.

**Goals for v1**

- Create, edit and delete reminders with five repeat modes: once, daily, weekly, monthly, yearly.
- Up to four alerts per reminder (on the day, 1 day, 1 week, 1 month before), at a chosen time.
- See what is coming on a Home list and a month Calendar.
- Snooze or mark an occurrence done from the notification itself.
- All data stays on the device; works with no internet.

**Non-goals for v1**

- No accounts, cloud sync or backend.
- No iOS build (the stack allows it later).
- No importing contacts' birthdays or Google Calendar sync (candidates for v2).
- No ads, analytics or tracking.

## Features

| Feature | Behavior |
| --- | --- |
| Reminder CRUD | Create, edit, delete. Delete asks for confirmation and offers Undo via snackbar for 5 s. |
| Types | Birthday, Anniversary, Bill, Other. Type sets the icon and color only; it never changes scheduling. |
| Repeat modes | Once, Daily, Weekly (one or more weekdays), Monthly (day of month), Yearly (day + month). |
| Optional year | Birthdays and anniversaries may store the original year. It drives "turns 30", "5th anniversary", and the live age on Detail (see Live age). |
| Alert time | One time of day per reminder, default 9:00 AM. |
| Lead alerts | Any combination of: on the day, 1 day before, 1 week before, 1 month before. At least one required. |
| Upcoming list | Home shows the next occurrence of every reminder, sorted by date, grouped into This week, Later this month, Later. |
| Next up card | The soonest occurrence, with countdown and quick actions. |
| Filters | Chips: All, Birthdays, Monthly, Weekly (filter by type or repeat mode). |
| Search | By title and note text. |
| Calendar | Month grid with a colored dot per repeat mode; tapping a day lists its occurrences. |
| Detail | Countdown, repeat and alert summary, note, history of past occurrences (done or missed). |
| Notification actions | Mark done, Snooze (1 hour, or tomorrow 9:00 AM). Tapping opens the Detail screen. |
| Send a wish | Opens the Android share sheet with a prefilled message, e.g. "Happy birthday, Omar!". |
| Settings | Language (English, Arabic), number style (123 or ١٢٣), theme (system, light, dark), first day of week, default alert time and leads, permission status, backup and restore. |
| Backup | Export all data to a JSON file via the system file picker; import replaces or merges. |

## Screens

All five screens are in `design/` in light (`design/`), dark (`design/dark/`), and Arabic right-to-left versions of Home and Detail (`design/ar/`); see `design/README.md`. Navigation is a bottom bar with Home, Calendar, All and Settings, plus a floating + button on Home.

| Screen | Contents | Interactions |
| --- | --- | --- |
| 1. Home (`design/Main.dc.html`) | Date header, search and bell buttons; accent "Next up" card (date tile, title, "turns N", repeat badge, Send a wish, Snooze); filter chips; grouped list of upcoming items (icon tile, title, repeat summary, relative day). | Tap item → Detail. + → New reminder. Swipe item left → Mark done. Pull to refresh recomputes occurrences. |
| 2. Calendar (`design/Calendar.dc.html`) | Month title with prev/next arrows; 7-column grid; up to 3 dots per day colored by repeat mode; legend; list of the selected day's items. | Tap a day to select it. Swipe grid horizontally to change month. Tap item → Detail. Today is tinted. |
| 3. New / Edit reminder (`design/AddReminder.dc.html`) | Title input; type chips; segmented control Once/Daily/Weekly/Monthly/Yearly with a one-line plain-English summary; date field whose label changes with the mode (Date, Starts, Day, Day of month); time; lead-alert chips; note; Save. | Changing the mode swaps the date picker: Weekly shows weekday toggles, Monthly a 1–31 picker, Yearly day + month (year optional). Save validates and schedules alarms. |
| 4. Detail (`design/Detail.dc.html`) | Colored header by type; live countdown to the next occurrence (days, hours, minutes, seconds); for birthdays with a known year, a live "Age right now" card; repeat and alert rows; note; past occurrences list; Snooze and Send a wish. | Edit icon → screen 3 prefilled. Overflow menu → Delete. |
| 5. Settings (`design/Settings.dc.html`) | Language, number style, theme, week start; default alert time and leads; notification, exact-alarm and battery status; Export, Import. | Permission rows deep-link to the right system settings page; "Fix" requests battery exemption. |

**Empty and error states** to build: no reminders yet ("Add your first reminder"), no results for a filter or search, and a persistent warning banner on Home when notifications or exact alarms are disabled.

## Arabic and right-to-left

Arabic is a v1 requirement: the app ships in English and Arabic, chosen in Settings, and the default follows the phone's language. `design/ar/` is the reference for the mirrored layout.

- **Localization:** Flutter gen-l10n with `app_en.arb` and `app_ar.arb`, `flutter_localizations` delegates, `supportedLocales: [en, ar]`. No hard-coded user-facing string anywhere.
- **Direction:** comes from the locale. Use `EdgeInsetsDirectional`, `AlignmentDirectional` and start/end everywhere, never left/right. In Arabic the FAB sits bottom-left. Directional icons (back arrow, chevrons, list icon) mirror; clock, check, bell and + do not.
- **Fonts:** IBM Plex Sans Arabic for Arabic text, Plus Jakarta Sans for Latin, both bundled; Arabic is the primary family in the Arabic theme with Latin as fallback.
- **Numbers:** a Settings switch between 123 and ١٢٣, defaulting to ١٢٣ when the language is Arabic. Route every displayed number (dates, countdown, age, times) through one `formatNumber()` helper; do not rely on locale defaults for digit shape.
- **Dates:** Gregorian calendar with Arabic month names (يناير … ديسمبر) via intl `DateFormat` in the `ar` locale; 12-hour time with ص / م.
- **Plurals:** ICU plural messages in the ARB files for counts (days left, age, years together); Arabic needs zero, one, two, few, many and other. Never concatenate a number and a word.
- **Week start:** defaults to Saturday when the region is Egypt or the language is Arabic, otherwise the locale default; user can change it.
- **Notifications:** text is rendered in the current language when scheduled, so a language change triggers `syncAlarms()`.
- **Tests:** golden tests of Home and Detail in `ar` and `en`; widget test that the back arrow and FAB mirror; Arabic plural forms for 0, 1, 2, 3, 11 and 100.

## Live age

For a birthday with a known birth year, Detail shows the person's age right now, updated every second, next to the countdown to their next birthday. The editor's optional "Birth year" field (stored as `known_year`) turns it on.

| Where | Shows |
| --- | --- |
| Detail, "Age right now" card | Years, months and days tiles; total days lived; a seconds-lived counter ticking every second; a "Live" marker |
| Detail header | Countdown to the next birthday in days, hours, minutes, seconds, and "turns N" |
| Home list row | Short form, e.g. "Yearly · 24 Oct · now 57" |
| Next up card | "Turns 30" |

**Calculation** (pure Dart in `core/`, injected `Clock`):

- `ageParts(birth, today)` returns the largest whole years Y, then months M, such that birth + Y years + M months (clamped to month end) is not after today; days D are what remains. Never subtract field by field: that gives negative days for births on the 29th–31st.
- A 29 February birth gains a year on 28 February in non-leap years, matching the reminder rule.
- Birth time is unknown, so it is taken as 00:00 local time.
- Anniversaries with a year show the count only ("5 years together"), no ticking card.

**Ticking:** a 1-second `Stream.periodic` that runs only while Detail is on screen and the app is in the foreground. Display-only: nothing is scheduled or stored per tick.

**Tests:** born 1968-10-24, today 2026-10-10 → 57 y 11 m 16 d; born 2000-01-31, today 2000-03-01 → 0 y 1 m 1 d; born 2004-02-29, today 2025-02-28 → 21 y 0 m 0 d; birthday today → countdown 0 and the card says "Today".

## Tech stack and architecture

Build it in **Flutter (Dart)**, Android first, with a local SQLite database and OS-scheduled notifications; there is no server. Use the latest stable versions of each package.

| Concern | Choice | Why |
| --- | --- | --- |
| UI | Flutter, Material 3, custom theme from the design tokens | One codebase, matches the design closely |
| State | Riverpod | Testable, no BuildContext needed in services |
| Database | Drift (SQLite) | Typed queries, migrations, reactive streams for the lists |
| Notifications | flutter_local_notifications with `zonedSchedule` and `AndroidScheduleMode.exactAllowWhileIdle` | Exact alarms that fire in Doze |
| Time zones | timezone + flutter_timezone | Schedules in the device's local zone, survives DST |
| Navigation | go_router | Deep links from notifications to Detail |
| Background re-sync | workmanager, daily periodic task | Safety net that tops up the alarm queue |
| Sharing | share_plus | "Send a wish" |
| Files | file_picker | Backup export and import |
| Tests | flutter_test, mocktail, Drift in-memory DB | Fast unit tests for recurrence logic |

Architecture (data flow):

```
Screens (Riverpod) --read/write--> Repository (Drift: reminders, occurrence_log, scheduled_alarms)
Screens --compute dates--> Recurrence engine (lib/core, pure Dart)
Repository -> Recurrence engine -> syncAlarms() (rolling 60-day window, max 400)
Resync triggers (app start, any edit, boot, time/zone change, daily WorkManager) --call--> syncAlarms()
syncAlarms() --schedule/cancel--> flutter_local_notifications --> Android AlarmManager
AlarmManager --user taps Done/Snooze--> Notification action handler --writes--> Repository
```

Screens never schedule alarms themselves: every change goes through the repository and then `syncAlarms()`, the only code that talks to the notifications plugin.

**Project layout** (feature-first):

```
lib/
  main.dart
  app/            router, theme, tokens
  core/           recurrence engine, clock, ids
  data/           drift db, tables, dao, repositories
  notifications/  scheduler, channels, action handlers, boot receiver glue
  features/
    home/  calendar/  editor/  detail/  settings/
  l10n/           app_en.arb, app_ar.arb (gen-l10n)
test/
  core/recurrence_test.dart
  notifications/scheduler_test.dart
```

**Rule:** the recurrence engine in `core/` is pure Dart with no Flutter or plugin imports, and takes the current time from an injected `Clock`.

## Data model

Occurrences are never stored ahead of time; they are computed from the rule. Only acted-on occurrences (done, snoozed, missed) are written to `occurrence_log`.

**reminders**

| Column | Type | Notes |
| --- | --- | --- |
| id | TEXT (UUID) | Primary key |
| title | TEXT | Required, 1–80 chars |
| type | TEXT enum | birthday, anniversary, bill, other |
| repeat | TEXT enum | once, daily, weekly, monthly, yearly |
| anchor_date | TEXT (yyyy-MM-dd) | Once: the date. Daily: start date. Yearly: day and month (year used only if known_year is set). Monthly: start month, day from day_of_month. |
| weekdays | INTEGER bitmask | Weekly only; bit 0 = Monday … bit 6 = Sunday (ISO) |
| day_of_month | INTEGER 1–31 | Monthly only |
| known_year | INTEGER, nullable | Birth or wedding year, for "turns N" |
| alert_minutes | INTEGER | Minutes after midnight, e.g. 540 = 9:00 AM |
| leads | INTEGER bitmask | bit 0 on the day, bit 1 −1 day, bit 2 −7 days, bit 3 −1 month |
| note | TEXT, nullable | Up to 500 chars |
| is_active | INTEGER bool | Paused reminders schedule nothing |
| created_at / updated_at | TEXT (ISO 8601 UTC) | |

**occurrence_log** — primary key (reminder_id, occurrence_date)

| Column | Type | Notes |
| --- | --- | --- |
| reminder_id | TEXT FK | Cascade delete |
| occurrence_date | TEXT (yyyy-MM-dd) | The event's date, not the alert's |
| status | TEXT enum | done, snoozed, missed |
| snoozed_until | TEXT, nullable | Local date-time |
| acted_at | TEXT (ISO 8601 UTC) | |

**scheduled_alarms** (bookkeeping, so alarms can be cancelled exactly)

| Column | Type | Notes |
| --- | --- | --- |
| notification_id | INTEGER | Unique 31-bit int passed to the plugin |
| reminder_id | TEXT FK | |
| occurrence_date | TEXT | |
| lead | TEXT enum | day0, day1, week1, month1, snooze |
| fire_at | TEXT | Local date-time it is scheduled for |

Settings live in shared_preferences. Backup JSON = `{ "version": 1, "reminders": [...], "occurrence_log": [...] }`; `scheduled_alarms` is never exported because it is rebuilt.

## Recurrence rules and edge cases

One function serves every screen and the scheduler: `List<DateOnly> occurrences(Reminder r, DateOnly from, DateOnly to)`. Work in calendar dates and only combine with `alert_minutes` and the local time zone at the very end.

| Repeat | Rule | Edge case and required behavior |
| --- | --- | --- |
| Once | Exactly anchor_date | Past once-reminders show as done or missed and schedule nothing. |
| Daily | Every date from anchor_date onward | None. |
| Weekly | Every date whose ISO weekday bit is set, from anchor_date onward | Must have at least one weekday. |
| Monthly | day_of_month of every month | Day 29–31 in a shorter month → last day of that month. Never skip a month. |
| Yearly | Same day and month every year | 29 February in a non-leap year → 28 February. |

**Lead alerts.** For each occurrence date D, fire at D, D−1 day, D−7 days and D−1 calendar month (same clamp-to-month-end rule), each at `alert_minutes` local time. Drop leads already in the past. If two leads collide on the same instant, send one notification.

**Display helpers** (in `core/`):

- `ageOn(r, D)` = D.year − known_year → "turns N" / "Nth anniversary"; hidden when known_year is null.
- `relativeLabel(D, today)` = Today, Tomorrow, weekday name within 7 days, "N d" beyond.
- `summary(r)` = e.g. "Every year on 24 October", "On the 31st of every month (last day in shorter months)".

**Time zone and DST.** Store dates and minutes-of-day, never absolute instants. Schedule with `TZDateTime` in the current local zone. Reschedule everything when the device time zone changes.

**Required unit tests** (minimum):

- Monthly on 31st across a year yields Jan 31, Feb 28, Mar 31, Apr 30 … Dec 31.
- Yearly 29 Feb yields 28 Feb in 2027 and 29 Feb in 2028.
- Weekly Mon + Thu from a Wednesday start returns Thursday first.
- Lead −1 month for an event on 31 March fires on 28 February (29 in leap years).
- An occurrence today whose alert time has passed schedules no alert but still shows on Home as Today.

## Notifications and Android scheduling

Schedule a **rolling window**: only alerts in the next 60 days, capped at 400 pending alarms. Some vendors cap pending alarms per app (around 500).

**`syncAlarms()`** (idempotent):

1. Compute every alert instant in [now, now + 60 days] for active reminders, minus done occurrences, plus active snoozes.
2. Sort by time, keep the first 400.
3. Diff against `scheduled_alarms`: cancel unwanted, schedule new, leave unchanged alone.
4. Write the new state in one transaction.

**Call it on:** app start; after any create, edit, delete, done or snooze; boot; time or time-zone change; daily WorkManager task.

| Permission / component | Why | Notes |
| --- | --- | --- |
| POST_NOTIFICATIONS | Android 13+ runtime consent | Ask during onboarding, after explaining why. |
| USE_EXACT_ALARM (or SCHEDULE_EXACT_ALARM) | Exact alarm times | USE_EXACT_ALARM is meant for alarm/calendar apps; if Play review rejects it, fall back to SCHEDULE_EXACT_ALARM and send the user to "Alarms & reminders" settings. Check `canScheduleExactNotifications()` before scheduling. |
| RECEIVE_BOOT_COMPLETED | Reschedule after reboot | Plugin's boot receiver, plus `syncAlarms()` on next app start. |
| TIME_SET, TIMEZONE_CHANGED receivers | Clock or zone changed | Trigger a resync. |
| Battery optimization | Xiaomi, Oppo, Huawei, Samsung kill background work | Settings shows status and a button to request exemption. |

| Channel id | Name | Importance |
| --- | --- | --- |
| reminders_due | Due today | High, sound + heads-up |
| reminders_upcoming | Upcoming (lead alerts) | Default |

- Title: reminder title (+ "turns N"). Body: Today / Tomorrow / In 1 week / In 1 month + repeat summary.
- Actions: **Done** and **Snooze** (1 hour, or tomorrow at alert time).
- Payload `reminderId|occurrenceDate`; tap opens Detail via go_router.
- Action taps must work with the app killed: top-level `@pragma('vm:entry-point')` background handler that opens the DB, writes `occurrence_log`, calls `syncAlarms()`.
- On app start, past occurrences (last 30 days) with no log entry whose alert fired are logged as `missed`.

## Design tokens

Put these in `lib/app/tokens.dart` and build the Material 3 `ThemeData` from them. Dark mode is required and drawn in `design/dark/`; its values are in the second table.

| Token | Light value | Used for |
| --- | --- | --- |
| color.background | #F3F4F6 | Screen background |
| color.surface | #FFFFFF | Cards, inputs, nav bar |
| color.ink | #15171C | Primary text, FAB, selected chips |
| color.inkMuted | #5B6070 | Secondary text, section labels |
| color.border | #D5D8DF | Unselected chips, input borders |
| color.divider | #E4E6EB | Row dividers, nav top border |
| color.accent | #2F5BEA | Next-up card, Save button, selected nav pill (#ECEFFC) |
| color.yearly | #C2410C (tint #F8EBE3) | Birthdays, anniversaries, yearly dots, Detail header |
| color.monthly | #0F766E (tint #E7EFEE) | Bills, monthly dots |
| color.weekly | #2F5BEA (tint #ECEFFC) | Weekly dots |
| color.daily | #7A7F8E | Daily dots |
| font.family | Plus Jakarta Sans (bundled asset) | All text |
| type.title | 28 / 800, letter-spacing −0.02em | Screen titles |
| type.heading | 20 / 800 | Card titles, app bar |
| type.body | 15 / 600–700 | List item titles, rows |
| type.caption | 13 / 600–700 | Secondary lines, section labels |
| radius.card | 18 (hero cards 24) | Cards |
| radius.control | 14 | Inputs, buttons, date tile |
| radius.chip | 18 | Chips |
| spacing.screen | 20 horizontal padding | All screens |
| size.touch | 44 minimum | Every tappable element |
| size.fab | 60, radius 20 | Add button |

**Dark theme** (same token names; anything not listed keeps its light value)

| Token | Dark value | Notes |
| --- | --- | --- |
| color.background | #0F1115 | |
| color.surface | #1A1D24 | Cards, inputs, nav bar |
| color.surfaceRaised | #23262E | Age tiles; selected segment #3A3F4B |
| color.ink | #ECEEF2 | Text; primary buttons, FAB and selected chips invert to #ECEEF2 fill with #0F1115 text |
| color.inkMuted | #9AA0AE | |
| color.border | #343944 | |
| color.divider | #2A2E37 | Also the segmented-control track |
| color.accent | #2F5BEA | Next-up card and Save keep white text; selected nav pill #24305A |
| color.yearly | #F28A52 (tint #3A2418) | Detail header #9A3409 |
| color.monthly | #3CC2AF (tint #12302C) | Also success / "Allowed" |
| color.weekly | #7E9CF8 (tint #1F2A4D) | Also link color |
| color.warning | #F0A04B (light: #B45309) | "Restricted" battery status |
| font.arabic | IBM Plex Sans Arabic 400–700 | Primary family in the Arabic locale |

Icons: 2 px stroke line icons (Lucide style) — `lucide_icons` or Material Symbols Outlined. No emoji in the UI.

## Build plan

Seven milestones, in order; each ends with a runnable app and passing tests.

1. **Skeleton.** Flutter project (package `app.reminders`, minSdk 26), Riverpod, go_router with 4 bottom-nav routes, light and dark themes from tokens, bundled fonts (Plus Jakarta Sans, IBM Plex Sans Arabic), English and Arabic localization with right-to-left layout.
   - [ ] Launches on emulator and real device; nav works; fonts and colors match the designs.
2. **Recurrence engine.** `core/` with `occurrences()`, leads, `ageOn`, `ageParts`, `formatNumber`, `relativeLabel`, `summary`, injectable `Clock`.
   - [ ] All tests under Recurrence rules and Live age pass; 100% line coverage on `core/`.
3. **Data layer.** Drift tables, DAO, repository with reactive streams, schema v1.
   - [ ] In-memory DB tests pass for create, edit, delete with cascade.
4. **Editor screen.** New/Edit with all five modes, validation, live summary line.
   - [ ] Each mode stores correct fields; invalid input is blocked with inline errors.
5. **Home, Calendar, Detail.** Bound to repository streams; filters, search, grouping, live countdown, live age card, history.
   - [ ] Screens match the designs; a new reminder appears instantly on Home and Calendar.
6. **Notifications.** Channels, permission onboarding, `syncAlarms()`, boot/time resync, Done and Snooze with app killed, WorkManager.
   - [ ] Real device: fires on time with screen off, after reboot; Done from a killed app shows in history.
7. **Settings, backup, polish.** Settings, JSON export/import, empty states, dark theme, permission banner, launcher icon from `assets/icon/` (flutter_launcher_icons, dev dependency), release build signed from a git-ignored `android/key.properties`.
   - [ ] Export → import on fresh install restores everything and reschedules; signed release AAB builds.

Rules: commit after each milestone; no extra packages without a reason in the commit message; all strings in `l10n/` in both English and Arabic.

## Testing

| Layer | What | How |
| --- | --- | --- |
| Unit | Recurrence engine, leads, labels, summary | Pure Dart, fixed `Clock` |
| Unit | `syncAlarms()` diff: adds, cancels, 400 cap, snooze | Fake notification plugin |
| Repository | CRUD, cascade, backup round-trip | Drift in-memory DB |
| Widget | Editor validation, mode switching, Home grouping | flutter_test, seeded repo |
| Manual | Real-device alarm behavior | Checklist below |

- [ ] Alert 2 minutes ahead fires with phone locked 10+ minutes.
- [ ] Reboot; a pending alert still fires.
- [ ] Change time zone; next alert stays at the same local time.
- [ ] Deny notification permission; Home banner appears.
- [ ] Revoke exact-alarm permission; banner appears, no crash.
- [ ] Swipe app away, tap Done; Detail shows done.
- [ ] Test on a Samsung or Xiaomi with default battery settings.
