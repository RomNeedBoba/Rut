import 'dart:async';
import 'package:flutter/material.dart';
import '../models/race_model.dart';

class RaceController with ChangeNotifier {
  Race? _currentRace;
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;

  Race? get currentRace => _currentRace;
  Duration get elapsedTime => _elapsedTime;

  void setRace(Race race) {
    _currentRace = race;
    _elapsedTime = Duration.zero;
    _timer?.cancel();
    notifyListeners();
  }

  void startRace() {
    if (_currentRace != null && _timer == null) {
      _currentRace = _currentRace!.copyWith(status: 'Started');
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _elapsedTime += const Duration(seconds: 1);
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void stopRace() {
    if (_currentRace != null) {
      _currentRace = _currentRace!.copyWith(status: 'Finished');
      _timer?.cancel();
      _timer = null;
      notifyListeners();
    }
  }

  void resetRace() {
    _elapsedTime = Duration.zero;
    _timer?.cancel();
    _timer = null;
    if (_currentRace != null) {
      _currentRace = _currentRace!.copyWith(status: 'Not Started');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
