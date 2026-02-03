import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';

/// A simple localization helper. All static strings used throughout the
/// application should be defined here with their translations. When
/// retrieving a string, the current language is read from the
/// [LanguageProvider]. Optional parameters can be passed to fill
/// placeholders within the string, e.g. `{level}`.
class Loc {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'LevelUp Problems',
      'welcome_title': 'Welcome to LevelUp Problems',
      'choose_language': 'Choose your language',
      'english': 'English',
      'arabic': 'Arabic',
      'start': 'Start',
      'home_title': 'Home',
      'current_level': 'Current Level: {level}',
      'progress': 'Progress',
      'problems_list': 'Problems List',
      'settings': 'Settings',
      'next_problem': 'Next Problem',
      'check': 'Check',
      'correct': 'Correct!',
      'incorrect': 'Incorrect',
      'try_again': 'Try again',
      'hint': 'Hint',
      'explanation': 'Explanation',
      'reset_progress': 'Reset Progress',
      'confirm_reset': 'Are you sure you want to reset your progress?',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'about': 'About',
      'about_description': 'This app helps you improve by solving problems from easiest to hardest.',
      'switch_language': 'Switch Language',
      'locked': 'Locked',
      'streak': 'Streak',
      'select_language': 'Select Language',
      'confirm_reset_title': 'Reset progress',
    },
    'ar': {
      'app_title': 'مسائل المستوى',
      'welcome_title': 'مرحبًا بك في مسائل المستوى',
      'choose_language': 'اختر لغتك',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'start': 'ابدأ',
      'home_title': 'الرئيسية',
      'current_level': 'المستوى الحالي: {level}',
      'progress': 'التقدم',
      'problems_list': 'قائمة المسائل',
      'settings': 'الإعدادات',
      'next_problem': 'المسألة التالية',
      'check': 'تحقق',
      'correct': 'صحيح!',
      'incorrect': 'خطأ',
      'try_again': 'حاول مرة أخرى',
      'hint': 'تلميح',
      'explanation': 'تفسير',
      'reset_progress': 'إعادة ضبط التقدم',
      'confirm_reset': 'هل أنت متأكد أنك تريد إعادة ضبط تقدمك؟',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'about': 'حول',
      'about_description': 'يساعدك هذا التطبيق على تحسين مهاراتك من خلال حل المسائل من الأسهل إلى الأصعب.',
      'switch_language': 'تغيير اللغة',
      'locked': 'مقفلة',
      'streak': 'سلسلة متتالية',
      'select_language': 'اختر اللغة',
      'confirm_reset_title': 'إعادة التقدم',
    },
  };

  /// Retrieves a localized string based on the current language.
  ///
  /// If the string contains placeholders like `{level}`, supply values
  /// through the [params] map. Unmatched placeholders remain unchanged.
  static String of(BuildContext context, String key, {Map<String, String>? params}) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    final lang = provider.locale.languageCode;
    String? value = _localizedValues[lang]?[key] ?? _localizedValues['en']?[key] ?? key;
    if (params != null) {
      params.forEach((placeholder, replacement) {
        value = value?.replaceAll('{$placeholder}', replacement);
      });
    }
    return value ?? key;
  }
}