import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/loc.dart';
import '../models/problem.dart';
import '../providers/language_provider.dart';
import '../providers/problem_provider.dart';
import 'problem_screen.dart';

/// Displays a scrollable list of all problems. Unlocked problems can be
/// tapped to open them; locked problems show a lock icon and are disabled.
class ProblemsListScreen extends StatelessWidget {
  const ProblemsListScreen({Key? key}) : super(key: key);

  void _openProblem(BuildContext context, int index, Problem problem) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProblemScreen(problemIndex: index, problem: problem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProblemProvider, LanguageProvider>(
      builder: (context, provider, langProvider, _) {
        final problems = provider.problems;
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(Loc.of(context, 'problems_list')),
          ),
          body: ListView.builder(
            itemCount: problems.length,
            itemBuilder: (context, index) {
              final problem = problems[index];
              final bool unlocked = provider.isUnlocked(index);
              final title = langProvider.isArabic ? problem.titleAr : problem.titleEn;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 1,
                child: ListTile(
                  onTap: unlocked ? () => _openProblem(context, index, problem) : null,
                  leading: CircleAvatar(
                    backgroundColor: unlocked
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primaryContainer,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(title),
                  trailing: unlocked
                      ? const Icon(Icons.arrow_forward_ios, size: 16)
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              Loc.of(context, 'locked'),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}