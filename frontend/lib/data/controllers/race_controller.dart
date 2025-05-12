import 'package:flutter/material.dart';
import '../models/race_model.dart';

class RaceController with ChangeNotifier {
  Race? _currentRace;
  Duration _elapsedTime = Duration.zero;

  Race? get currentRace => _currentRace;
  Duration get elapsedTime => _elapsedTime;

  void setRace(Race race) {
    _currentRace = race;
    _elapsedTime = Duration.zero;
    notifyListeners();
  }

  void startRace() {
    if (_currentRace != null) {
      _currentRace = _currentRace!.copyWith(status: 'Started');
      notifyListeners();
      // Start timer logic can go here later
    }
  }

  void stopRace() {
    if (_currentRace != null) {
      _currentRace = _currentRace!.copyWith(status: 'Finished');
      notifyListeners();
    }
  }

  void resetRace() {
    _elapsedTime = Duration.zero;
    if (_currentRace != null) {
      _currentRace = _currentRace!.copyWith(status: 'Not Started');
      notifyListeners();
    }
  }

  void updateElapsedTime(Duration time) {
    _elapsedTime = time;
    notifyListeners();
  }
}
