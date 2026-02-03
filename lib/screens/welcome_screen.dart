import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/loc.dart';
import '../providers/language_provider.dart';
import 'home_screen.dart';

/// The initial screen shown on first launch. It allows the user to select
/// their preferred language (English or Arabic). Once a language is
/// selected, it is saved and the user is navigated to the [HomeScreen].
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  Future<void> _selectLanguage(BuildContext context, String code) async {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    await langProvider.setLocale(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang_code', code);
    // After setting the language, navigate to the home screen.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Loc.of(context, 'welcome_title'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Text(
                Loc.of(context, 'choose_language'),
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectLanguage(context, 'en'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: theme.colorScheme.primary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(Loc.of(context, 'english')),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _selectLanguage(context, 'ar'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: theme.colorScheme.secondary,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(Loc.of(context, 'arabic')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}