import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/loc.dart';
import '../providers/problem_provider.dart';
import '../providers/language_provider.dart';
import 'problem_screen.dart';
import 'problems_list_screen.dart';
import 'settings_screen.dart';

/// Displays the user's progress and allows navigation to the next problem,
/// the list of all problems, or the settings page.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _openNextProblem(BuildContext context) {
    final problemProvider = Provider.of<ProblemProvider>(context, listen: false);
    final index = problemProvider.unlockedIndex;
    final problem = problemProvider.getProblem(index);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProblemScreen(problemIndex: index, problem: problem),
      ),
    );
  }

  void _openProblemsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProblemsListScreen()),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProblemProvider>(builder: (context, provider, _) {
      final isLoaded = !provider.isLoading;
      final total = provider.problems.length;
      final unlocked = provider.unlockedIndex;
      final theme = Theme.of(context);
      final langProvider = Provider.of<LanguageProvider>(context, listen: false);
      return Scaffold(
        appBar: AppBar(
          title: Text(Loc.of(context, 'home_title')),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _openSettings(context),
            ),
          ],
        ),
        body: isLoaded
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Loc.of(context, 'current_level', params: {
                                'level': (unlocked + 1).toString(),
                              }),
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: total > 0 ? (unlocked + 1) / total : 0,
                              backgroundColor: theme.colorScheme.primaryContainer,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${Loc.of(context, 'progress')}: ${(unlocked + 1)}/$total',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _openNextProblem(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: theme.colorScheme.primary,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text(Loc.of(context, 'next_problem')),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => _openProblemsList(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        side: BorderSide(color: theme.colorScheme.primary),
                      ),
                      child: Text(Loc.of(context, 'problems_list'),
                          style: TextStyle(color: theme.colorScheme.primary)),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}