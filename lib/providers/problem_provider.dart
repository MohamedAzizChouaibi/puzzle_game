import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/problem.dart';
import '../services/problem_service.dart';

/// Provider responsible for managing the user's progress through the problem set.
class ProblemProvider with ChangeNotifier {
  /// List of all problems loaded from the JSON asset.
  List<Problem> _problems = [];

  /// Index of the last unlocked problem (0‑based). A value of 0 means only
  /// the first problem is unlocked. When the user solves a problem
  /// correctly, this index increments.
  int _unlockedIndex = 0;

  /// Indicates whether problems are currently being loaded.
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  int get unlockedIndex => _unlockedIndex;

  List<Problem> get problems => _problems;

  /// Load problems from the asset and restore the unlock index from
  /// persistent storage. This should be called once when the app starts.
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _problems = await ProblemService.loadProblems();
    final prefs = await SharedPreferences.getInstance();
    _unlockedIndex = prefs.getInt('unlocked_index') ?? 0;
    _isLoading = false;
    notifyListeners();
  }

  /// Determines whether the problem at [index] is unlocked for the user.
  bool isUnlocked(int index) => index <= _unlockedIndex;

  /// Returns the problem at the specified [index].
  Problem getProblem(int index) => _problems[index];

  /// Marks the current problem as solved and unlocks the next one. If the
  /// user is already at the last problem, this does nothing.
  Future<void> markCurrentSolved(int index) async {
    if (index >= _problems.length - 1) return;
    if (_unlockedIndex < index + 1) {
      _unlockedIndex = index + 1;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('unlocked_index', _unlockedIndex);
      notifyListeners();
    }
  }

  /// Resets progress back to the first problem. This clears the unlocked
  /// index and persists the change.
  Future<void> resetProgress() async {
    _unlockedIndex = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unlocked_index', _unlockedIndex);
    notifyListeners();
  }
}