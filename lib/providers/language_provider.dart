import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider that holds the current locale/language of the app.
///
/// By default, the app will start in English unless a saved preference
/// overrides it. Changing the language updates the locale and notifies
/// listeners to rebuild widgets with the new language.
class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  bool get isArabic => _locale.languageCode == 'ar';

  /// Loads the saved language code from shared preferences. If none is
  /// stored, defaults to English. This should be called when the
  /// provider is first created.
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('lang_code') ?? 'en';
    _locale = Locale(code);
    notifyListeners();
  }

  /// Persists and applies a new language to the app. Supported values
  /// are 'en' and 'ar'.
  Future<void> setLocale(String languageCode) async {
    if (_locale.languageCode == languageCode) return;
    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang_code', languageCode);
    notifyListeners();
  }
}