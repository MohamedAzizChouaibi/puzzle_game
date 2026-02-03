import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/problem.dart';

/// Service responsible for loading the problem definitions from a local asset.
class ProblemService {
  /// Loads problems from the JSON file stored in the assets folder.
  ///
  /// Returns a list of [Problem] objects. If the file fails to load or
  /// contains invalid data, an empty list is returned. Caller should
  /// differentiate between an empty result due to no problems and one due to
  /// an error by catching thrown exceptions if needed.
  static Future<List<Problem>> loadProblems() async {
    try {
      final jsonString = await rootBundle.loadString('assets/problems.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((e) => Problem.fromJson(e)).toList();
    } catch (e) {
      // In case of any error (e.g. missing asset, JSON parse error), return an empty list.
      return [];
    }
  }
}