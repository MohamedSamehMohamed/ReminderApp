# Screen designs

Each `.dc.html` file is one 390×844 phone screen. They are design references, not runnable pages: they need a design-canvas runtime (`support.js`, not included) to render, so read them as source and use the PNGs in `screenshots/` for the look.

How to read them:

- Layout, colors, sizes, radii and fonts are all in the inline `style="…"` attributes. Use those exact values (they match the token tables in `../SPEC.md`).
- `{{accent}}` = `#2F5BEA`. Other `{{…}}` holes are filled by the `<script type="text/x-dc">` block at the bottom of each file.
- `<sc-for list="{{x}}">` repeats its children per item; `<sc-if>` is a conditional.
- `<a href="Other.dc.html">` marks navigation between screens.
- Icons are inline 24×24 stroke SVGs (Lucide style).
- The Detail screens' script contains a reference implementation of the live age and countdown math (JavaScript). The Dart version must follow the `ageParts` rule in SPEC.md, which also handles births on the 29th–31st.

| File | Screen |
| --- | --- |
| Main.dc.html | 1. Home — upcoming list and Next up card |
| Calendar.dc.html | 2. Calendar — October 2026, colored dots per repeat mode |
| AddReminder.dc.html | 3. New / Edit reminder — repeat modes, birth year, lead alerts |
| Detail.dc.html | 4. Reminder detail — live countdown and live age |
| Settings.dc.html | 5. Settings — language, numbers, theme, defaults, permissions, backup |
| dark/*.dc.html | The same five screens in the dark theme |
| ar/Home.dc.html, ar/Detail.dc.html | Arabic, right-to-left, Arabic-Indic digits |
