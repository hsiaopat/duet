import 'package:flutter/material.dart';

class ResultStore extends ChangeNotifier {
  Map<String, String> _results = {};

  Map<String, String> get results => _results;

  void updateResults(Map<String, String> newResults) {
    _results = newResults;
    notifyListeners();
  }

  void clearResults() {
    _results = {};
    notifyListeners();
  }
}
