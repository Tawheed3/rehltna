import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  late SharedPreferences _prefs;
  bool _isDarkMode = false;
  Locale _locale = const Locale('ar');

  bool get isDarkMode => _isDarkMode;
  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
  }

  void _loadSettings() {
    _isDarkMode = _prefs.getBool('dark_mode') ?? false;
    final String langCode = _prefs.getString('language') ?? 'ar';
    _locale = Locale(langCode);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('dark_mode', value);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    await _prefs.setString('language', languageCode);
    notifyListeners();
  }

  String getText(String ar, String en) {
    return languageCode == 'ar' ? ar : en;
  }
}