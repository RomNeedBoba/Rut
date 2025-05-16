import 'package:flutter/material.dart';
import '../models/result_model.dart';

class ResultController with ChangeNotifier {
  List<Result> _results = [];

  List<Result> get results => List.unmodifiable(_results);

  void setResults(List<Result> list) {
    _results = list;
    notifyListeners();
  }

  void addResult(Result result) {
    _results.add(result);
    notifyListeners();
  }

  void clearResults() {
    _results.clear();
    notifyListeners();
  }

  Result? getById(String id) {
    try {
      return _results.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Convert results to JSON for push
  List<Map<String, dynamic>> toJsonList() {
    return _results
        .map((r) => {
              "participantName": r.participantName,
              "bibNumber": r.bibNumber,
              "swimTime": r.swimTime,
              "cycleTime": r.cycleTime,
              "runTime": r.runTime,
              "totalTime": r.totalTime,
            })
        .toList();
  }
}
