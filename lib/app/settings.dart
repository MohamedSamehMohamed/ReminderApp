import 'package:flutter/material.dart' hide RepeatMode;
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  final SharedPreferences prefs;
  AppSettings(this.prefs);
  String get language =>
      prefs.getString('language') ??
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  bool get arabic => language == 'ar';
  bool get arabicDigits => prefs.getBool('arabicDigits') ?? arabic;
  ThemeMode get theme =>
      ThemeMode.values.byName(prefs.getString('theme') ?? 'system');
  int get weekStart => prefs.getInt('weekStart') ?? (arabic ? 6 : 7);
  int get defaultMinutes => prefs.getInt('defaultMinutes') ?? 540;
  int get defaultLeads => prefs.getInt('defaultLeads') ?? 1;
  bool get onboarded => prefs.getBool('onboarded') ?? false;
  Future<void> set(String key, Object value) async {
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else {
      await prefs.setString(key, value.toString());
    }
    notifyListeners();
  }
}
