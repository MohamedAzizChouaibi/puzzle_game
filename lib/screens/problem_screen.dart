import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/problem.dart';
import '../providers/problem_provider.dart';
import '../providers/language_provider.dart';
import '../localization/loc.dart';

/// Screen that allows the user to solve a single problem. Supports
/// multiple‑choice, numeric and short text answers. After a correct
/// submission the user is shown the explanation and the next problem is
/// unlocked. Incorrect answers produce gentle feedback and an optional
/// hint.
class ProblemScreen extends StatefulWidget {
  final int problemIndex;
  final Problem problem;

  const ProblemScreen({Key? key, required this.problemIndex, required this.problem}) : super(key: key);

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  String? _selectedOption;
  final TextEditingController _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Converts a string containing Arabic numerals into western digits. This
  /// allows numeric input to be compared against the correct answer when
  /// users enter Arabic numerals. Non‑digit characters remain unchanged.
  String _convertArabicDigits(String input) {
    const arabicToWestern = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };
    return input.split('').map((c) => arabicToWestern[c] ?? c).join();
  }

  /// Evaluates the user's answer and returns true if it matches the
  /// problem's correct answer or options.
  bool _isCorrect() {
    final p = widget.problem;
    switch (p.type) {
      case ProblemType.mcq:
        if (_selectedOption == null) return false;
        final correctOpts = p.correctOptions ?? [];
        return correctOpts.map((e) => e.trim().toLowerCase()).contains(_selectedOption!.trim().toLowerCase());
      case ProblemType.numeric:
        final input = _convertArabicDigits(_controller.text.trim());
        if (input.isEmpty) return false;
        final correct = p.correctAnswer ?? '';
        return input == correct;
      case ProblemType.text:
        final input = _controller.text.trim().toLowerCase();
        if (input.isEmpty) return false;
        final correct = (p.correctAnswer ?? '').trim().toLowerCase();
        return input == correct;
    }
  }

  /// Handles the check button press. If the answer is correct, unlocks
  /// the next problem and shows a success dialog. Otherwise displays a
  /// snack bar with feedback and an optional hint.
  Future<void> _handleCheck() async {
    if (_submitting) return;
    setState(() {
      _submitting = true;
    });
    final correct = _isCorrect();
    if (correct) {
      // Unlock next problem.
      final provider = Provider.of<ProblemProvider>(context, listen: false);
      await provider.markCurrentSolved(widget.problemIndex);
      // Show success dialog with explanation.
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              Loc.of(context, 'correct'),
              style: TextStyle(color: Colors.green),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    widget.problem.explanationEn.isNotEmpty
                        ? (Provider.of<LanguageProvider>(context, listen: false).isArabic
                            ? widget.problem.explanationAr
                            : widget.problem.explanationEn)
                        : '',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(Loc.of(context, 'confirm')),
              ),
            ],
          );
        },
      );
      // After closing the dialog, pop back to previous screen.
      Navigator.of(context).pop();
    } else {
      // Show incorrect feedback with optional hint.
      final hint = Provider.of<LanguageProvider>(context, listen: false).isArabic
          ? widget.problem.hintAr
          : widget.problem.hintEn;
      final snackBar = SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Loc.of(context, 'incorrect')),
            if (hint != null && hint.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('${Loc.of(context, 'hint')}: $hint'),
            ],
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red[400],
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      _submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problem;
    final langProvider = Provider.of<LanguageProvider>(context);
    final theme = Theme.of(context);
    final isArabic = langProvider.isArabic;
    final statement = isArabic ? problem.statementAr : problem.statementEn;
    List<Widget> inputWidgets = [];
    switch (problem.type) {
      case ProblemType.mcq:
        final options = isArabic ? (problem.optionsAr ?? []) : (problem.optionsEn ?? []);
        for (final option in options) {
          inputWidgets.add(RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ));
        }
        break;
      case ProblemType.numeric:
      case ProblemType.text:
        inputWidgets.add(TextField(
          controller: _controller,
          keyboardType: problem.type == ProblemType.numeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: problem.type == ProblemType.numeric
                ? (isArabic ? 'أدخل قيمة رقمية' : 'Enter a number')
                : (isArabic ? 'أدخل الإجابة' : 'Enter your answer'),
          ),
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        ));
        break;
    }
    final bool hasInput;
    switch (problem.type) {
      case ProblemType.mcq:
        hasInput = _selectedOption != null;
        break;
      default:
        hasInput = _controller.text.trim().isNotEmpty;
        break;
    }
    return Directionality(
      textDirection: langProvider.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(langProvider.isArabic ? problem.titleAr : problem.titleEn),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statement,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              ...inputWidgets,
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: hasInput ? _handleCheck : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: theme.colorScheme.primary,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: Text(Loc.of(context, 'check')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}