import 'package:flutter/material.dart' hide RepeatMode;

abstract final class Tokens {
  static const background = Color(0xFFF3F4F6),
      surface = Color(0xFFFFFFFF),
      ink = Color(0xFF15171C),
      muted = Color(0xFF5B6070),
      border = Color(0xFFD5D8DF),
      divider = Color(0xFFE4E6EB),
      accent = Color(0xFF2F5BEA);
  static const darkBackground = Color(0xFF0F1115),
      darkSurface = Color(0xFF1A1D24),
      darkInk = Color(0xFFECEEF2),
      darkMuted = Color(0xFF9AA0AE),
      darkBorder = Color(0xFF343944),
      darkDivider = Color(0xFF2A2E37),
      raised = Color(0xFF23262E);
  static const yearly = Color(0xFFC2410C),
      monthly = Color(0xFF0F766E),
      weekly = accent,
      daily = Color(0xFF7A7F8E);
  static const darkYearly = Color(0xFFF28A52),
      darkMonthly = Color(0xFF3CC2AF),
      darkWeekly = Color(0xFF7E9CF8);
  static const yearlyTint = Color(0xFFF8EBE3),
      monthlyTint = Color(0xFFE7EFEE),
      weeklyTint = Color(0xFFECEFFC);
  static const darkYearlyTint = Color(0xFF3A2418),
      darkMonthlyTint = Color(0xFF12302C),
      darkWeeklyTint = Color(0xFF1F2A4D),
      detailHeader = Color(0xFF9A3409);
  static const warning = Color(0xFFB45309), darkWarning = Color(0xFFF0A04B);
  static const card = 18.0,
      hero = 24.0,
      control = 14.0,
      chip = 18.0,
      screen = 20.0,
      touch = 44.0,
      fab = 60.0;
  static ThemeData theme(bool dark, bool arabic) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: accent,
          brightness: dark ? Brightness.dark : Brightness.light,
        ).copyWith(
          surface: dark ? darkSurface : surface,
          onSurface: dark ? darkInk : ink,
          primary: accent,
          outline: dark ? darkBorder : border,
        );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: arabic ? 'IBM Plex Sans Arabic' : 'Plus Jakarta Sans',
      fontFamilyFallback: const ['Plus Jakarta Sans', 'IBM Plex Sans Arabic'],
    );
    return base.copyWith(
      scaffoldBackgroundColor: dark ? darkBackground : background,
      dividerColor: dark ? darkDivider : divider,
      textTheme: base.textTheme.copyWith(
        headlineLarge: base.textTheme.headlineLarge!.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.56,
        ),
        titleLarge: base.textTheme.titleLarge!.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: base.textTheme.titleMedium!.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: base.textTheme.bodyMedium!.copyWith(
          fontSize: 13,
          color: dark ? darkMuted : muted,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? darkBackground : background,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(control),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(control),
          borderSide: BorderSide(color: scheme.outline),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(44, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(control),
          ),
          textStyle: base.textTheme.labelLarge!.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: dark ? darkWeeklyTint : weeklyTint,
        labelTextStyle: WidgetStateProperty.all(
          base.textTheme.labelLarge!.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(card),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: scheme.outline),
        backgroundColor: scheme.surface,
        selectedColor: scheme.primaryContainer,
        showCheckmark: false,
        labelStyle: base.textTheme.labelLarge!.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
