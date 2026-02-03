import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'localization/loc.dart';
import 'providers/language_provider.dart';
import 'providers/problem_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialise shared preferences to determine if a language has been selected.
  final prefs = await SharedPreferences.getInstance();
  final hasLanguage = prefs.containsKey('lang_code');
  // Initialise providers.
  final languageProvider = LanguageProvider();
  await languageProvider.loadLocale();
  final problemProvider = ProblemProvider();
  await problemProvider.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
      ChangeNotifierProvider<ProblemProvider>.value(value: problemProvider),
    ],
    child: LevelUpApp(initialShowWelcome: !hasLanguage),
  ));
}

/// Root widget for the LevelUp Problems app. It sets up localization,
/// theming, and determines which initial screen to display.
class LevelUpApp extends StatelessWidget {
  final bool initialShowWelcome;

  const LevelUpApp({Key? key, this.initialShowWelcome = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, langProvider, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Loc.of(context, 'app_title'),
        locale: langProvider.locale,
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0D47A1), // deep blue primary seed
            primary: const Color(0xFF0D47A1),
            secondary: const Color(0xFF008080),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            background: const Color(0xFFF5F5F5),
          ),
          textTheme: langProvider.isArabic
              ? GoogleFonts.cairoTextTheme()
              : GoogleFonts.robotoTextTheme(),
        ),
        home: initialShowWelcome ? const WelcomeScreen() : const HomeScreen(),
      );
    });
  }
}