import 'dart:convert';

/// Enumeration of the supported problem types.
///
/// - [ProblemType.mcq]: a multiple‑choice question. The user must pick one
///   answer from a list of options. The correct choice(s) are stored in
///   [correctOptions].
/// - [ProblemType.numeric]: an answer that should parse to a number. The
///   correct value is stored in [correctAnswer] as a string; the input
///   field accepts both Arabic and western numerals.
/// - [ProblemType.text]: a short free‑text answer. Comparison is case
///   insensitive.
enum ProblemType { mcq, numeric, text }

/// Model representing a single problem in the learning app.
class Problem {
  final int id;
  final int difficulty;
  final ProblemType type;
  final String titleEn;
  final String titleAr;
  final String statementEn;
  final String statementAr;
  final String? hintEn;
  final String? hintAr;
  final String explanationEn;
  final String explanationAr;
  final String? correctAnswer;
  final List<String>? correctOptions;
  final List<String>? optionsEn;
  final List<String>? optionsAr;

  Problem({
    required this.id,
    required this.difficulty,
    required this.type,
    required this.titleEn,
    required this.titleAr,
    required this.statementEn,
    required this.statementAr,
    required this.explanationEn,
    required this.explanationAr,
    this.hintEn,
    this.hintAr,
    this.correctAnswer,
    this.correctOptions,
    this.optionsEn,
    this.optionsAr,
  });

  /// Factory constructor to create a [Problem] from a JSON map.
  factory Problem.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String? ?? 'text';
    final ProblemType type;
    switch (typeString) {
      case 'mcq':
        type = ProblemType.mcq;
        break;
      case 'numeric':
        type = ProblemType.numeric;
        break;
      default:
        type = ProblemType.text;
    }
    return Problem(
      id: json['id'] as int,
      difficulty: json['difficulty'] as int,
      type: type,
      titleEn: json['title_en'] as String? ?? '',
      titleAr: json['title_ar'] as String? ?? '',
      statementEn: json['statement_en'] as String? ?? '',
      statementAr: json['statement_ar'] as String? ?? '',
      hintEn: json['hint_en'] as String?,
      hintAr: json['hint_ar'] as String?,
      explanationEn: json['explanation_en'] as String? ?? '',
      explanationAr: json['explanation_ar'] as String? ?? '',
      correctAnswer: json['correctAnswer'] as String?,
      correctOptions: (json['correctOptions'] as List?)?.map((e) => e.toString()).toList(),
      optionsEn: (json['options_en'] as List?)?.map((e) => e.toString()).toList(),
      optionsAr: (json['options_ar'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}