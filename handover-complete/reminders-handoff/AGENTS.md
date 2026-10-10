# AGENTS.md — Reminders app

You are building an Android app called "Reminders" in Flutter.

- `SPEC.md` is the source of truth for behavior, data model, recurrence rules, notifications and design tokens.
- `design/screenshots/` has PNGs of every screen (light, dark, Arabic): the visual reference. Match their layout, spacing, colors and type exactly.
- `design/*.dc.html` are the same screens as source, for exact values (see `design/README.md`; they are not runnable).
- `assets/icon/` has the app icon (see `assets/icon/README.md`).
- Fonts: download Plus Jakarta Sans and IBM Plex Sans Arabic (both SIL Open Font License) from Google Fonts as TTF into `assets/fonts/` in Milestone 1.
- Release signing: never generate or commit a keystore. Read signing config from a git-ignored `android/key.properties` that the owner provides.

## How to work

Work milestone by milestone, in the order given in SPEC.md → "Build plan". For each milestone:

1. State what you will build and which files you will create or change.
2. Write the code in full (no placeholders, no "rest unchanged").
3. Write the tests named in its acceptance criteria and run them (`flutter test`).
4. Stop and wait for confirmation before starting the next milestone.

## Hard rules

- Use only the packages in the SPEC "Tech stack" table unless you explain why.
- The recurrence engine in `lib/core/` is pure Dart, uses an injected `Clock`, and must pass every test listed under "Recurrence rules".
- Store dates and minutes-of-day, never absolute timestamps, for reminder rules.
- Notifications use a rolling 60-day window capped at 400 alarms via an idempotent `syncAlarms()`. Screens never schedule alarms directly.
- The app supports English and Arabic from day one: all UI strings go through `l10n/` (ARB files for both), layouts use start/end (never left/right) so they mirror in right-to-left, and every displayed number goes through `formatNumber()`.
- Colors, type and radii come only from `lib/app/tokens.dart`, with light and dark themes.
- Live age and countdown on Detail are display-only and tick once per second only while the screen is visible.
- If the spec is ambiguous, ask one question before coding that part instead of guessing.

Start with Milestone 1.
