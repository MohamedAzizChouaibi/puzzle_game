import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/loc.dart';
import '../providers/language_provider.dart';
import '../providers/problem_provider.dart';

/// Screen for app settings, including language selection, progress reset and
/// about information.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> _confirmReset(BuildContext context) async {
    final problemProvider = Provider.of<ProblemProvider>(context, listen: false);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Loc.of(context, 'confirm_reset_title')),
          content: Text(Loc.of(context, 'confirm_reset')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(Loc.of(context, 'cancel')),
            ),
            TextButton(
              onPressed: () async {
                await problemProvider.resetProgress();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(Loc.of(context, 'reset_progress') + ' ✔'),
                  ),
                );
              },
              child: Text(Loc.of(context, 'confirm')),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAbout(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Loc.of(context, 'about')),
          content: Text(Loc.of(context, 'about_description')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(Loc.of(context, 'confirm')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Loc.of(context, 'settings')),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(Loc.of(context, 'switch_language')),
            subtitle: Text(langProvider.isArabic ? Loc.of(context, 'arabic') : Loc.of(context, 'english')),
            trailing: DropdownButton<String>(
              value: langProvider.locale.languageCode,
              items: [
                DropdownMenuItem(value: 'en', child: Text(Loc.of(context, 'english'))),
                DropdownMenuItem(value: 'ar', child: Text(Loc.of(context, 'arabic'))),
              ],
              onChanged: (value) {
                if (value != null) {
                  langProvider.setLocale(value);
                }
              },
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: Text(Loc.of(context, 'reset_progress')),
            trailing: const Icon(Icons.restore),
            onTap: () => _confirmReset(context),
          ),
          const Divider(height: 0),
          ListTile(
            title: Text(Loc.of(context, 'about')),
            trailing: const Icon(Icons.info_outline),
            onTap: () => _showAbout(context),
          ),
        ],
      ),
    );
  }
}