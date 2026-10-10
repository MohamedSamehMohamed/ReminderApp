# App icon

| File | Use |
| --- | --- |
| icon.svg / icon-1024.png | Master icon (rounded square, #2F5BEA) |
| icon-512-play-store.png | Google Play store listing icon (512×512) |
| foreground.svg / foreground-1024.png | Android adaptive icon foreground (transparent, artwork inside the safe zone) |

Adaptive icon background colour: `#2F5BEA`.

Generate the launcher icons in Milestone 7 with `flutter_launcher_icons` (dev dependency only):

```yaml
flutter_launcher_icons:
  android: true
  ios: false
  image_path: assets/icon/icon-1024.png
  adaptive_icon_background: "#2F5BEA"
  adaptive_icon_foreground: assets/icon/foreground-1024.png
```
