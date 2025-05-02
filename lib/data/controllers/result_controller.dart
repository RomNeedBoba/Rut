import 'package:flutter/material.dart';
import '../models/result_model.dart';

class ResultController with ChangeNotifier {
  List<Result> _results = [];

  List<Result> get results => _results;

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
}
