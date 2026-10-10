# Reminders

An offline Android reminder app built with Flutter. English and Arabic, light and dark themes, local SQLite storage, calendar views, birthday age counters, and OS-scheduled notifications.

## Run

Requires Flutter 3.47.7 / Dart 3.13.5, Java 21, and Android SDK 36. Minimum device version: Android 8 (API 26).

```powershell
flutter pub get
flutter gen-l10n
dart run build_runner build
flutter run
```

This workstation has project-local SDK tools under the ignored `.tools/` directory. To use them, run `. ./scripts/env.ps1` first. Tool downloads and machine-specific paths are not committed.

## Validate and build

```powershell
flutter analyze
flutter test --coverage
flutter build apk --debug
```

The installable test APK is `build/app/outputs/flutter-apk/app-debug.apk`. It uses Android's development signing identity. It is not a production release or a Play Store upload.

`scripts/build.ps1` runs code generation, analysis, tests and an APK build. GitHub Actions performs the same checks and uploads a test APK artifact.

## Production signing

The owner must supply an existing keystore and a git-ignored `android/key.properties`:

```properties
storeFile=C:/private/location/reminders-release.jks
storePassword=YOUR_PASSWORD
keyAlias=YOUR_ALIAS
keyPassword=YOUR_PASSWORD
```

Then run `flutter build apk --release` or `flutter build appbundle --release`. Never add keystores or signing passwords to Git. Without this configuration, release builds are unsigned; use the debug APK for installation and testing.

## Features

- Create, edit and delete once, daily, weekly, monthly and yearly reminders; deletion has a five-second Undo.
- Month-end and February 29 clamping; four optional lead alerts at a chosen local time.
- Upcoming list, filters, title/note search, month calendar, occurrence history and notification deep links.
- Done and two snooze actions, including background notification handling.
- A rolling 60-day notification window capped at 400 alarms, with idempotent diffing and daily WorkManager resync.
- Boot, clock, timezone and exact-alarm permission-change receivers; inexact scheduling fallback when exact permission is denied.
- Localized English/Arabic text, selectable digits, RTL layouts, bundled open-license fonts and light/dark themes.
- Display-only live birthday age and countdown; ticks stop while Detail is covered or the app is in the background.
- Local JSON export and replace/merge import through the system picker. Import validates and runs transactionally.

## Structure

- `lib/core/`: pure Dart calendar dates, rules, validation, ages, identifiers and number formatting.
- `lib/data/`: Drift schema, reactive repository and transactional backups.
- `lib/notifications/`: alarm planning/diffing and Android plugin integration.
- `lib/features/`: Home, Calendar, Editor, Detail and Settings.
- `lib/app/`: theme tokens, settings, providers, navigation and presentation formatting.
- `lib/l10n/`: English/Arabic ARB files and generated localization code.
- `handover-complete/reminders-handoff/`: the supplied specification, design sources and screenshots.

SQLite support (`sqlite3`, `path_provider`, `path`) and Drift generation (`drift_dev`, `build_runner`) are supporting dependencies required by the specified database. `shared_preferences` and `intl` implement the settings/localization requirements; `flutter_launcher_icons` is the handover's prescribed development tool.

The development-only `path_provider_platform_interface` enables isolated scheduler tests without accessing real app storage. `scripts/publish.ps1` creates a private GitHub repository, pushes committed source and uploads the verified test APK as a prerelease after GitHub login.

## Testing limits

Automated checks cover recurrence, leads, age edge cases, the alarm window/cap/diff, repository CRUD/cascades, backup round trips, editor validation, list filtering, Arabic plurals, RTL and screenshot regressions. Golden images are Flutter-rendered regression references, not a claim that every pixel matches the supplied design screenshots.

Before production distribution, complete the real-phone checklist in the specification: locked-screen firing, reboot, timezone changes, revoked permissions, notification actions while the app is killed, and Samsung/Xiaomi battery behavior. A successful APK build does not verify these Android behaviors. Missed history records elapsed scheduled alerts; Android does not provide proof that a user saw a notification.
