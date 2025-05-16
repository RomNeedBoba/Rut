import 'package:flutter/material.dart';

class TrackingController with ChangeNotifier {
  String _currentSegment = 'swim';

  final Map<String, Map<String, Duration>> _participantRecordedTimes = {};

  // Race info to track when saving/pushing results
  String? _raceId;
  String? _raceName;

  String get currentSegment => _currentSegment;
  String? get raceId => _raceId;
  String? get raceName => _raceName;

  // Call this when starting the race
  void setRace(String raceId, String raceName) {
    _raceId = raceId;
    _raceName = raceName;
    notifyListeners();
  }

  void setSegment(String segment, Duration globalTime) {
    _currentSegment = segment;
    notifyListeners();
  }

  bool hasParticipantRecorded(String participantId) {
    return (_participantRecordedTimes[participantId]?[_currentSegment] ??
            Duration.zero) !=
        Duration.zero;
  }

  void recordParticipant(String participantId, Duration globalElapsed,
      {bool forceUpdate = false}) {
    final requiredPrevious = {
      'cycle': 'swim',
      'run': 'cycle',
    };

    // Check if previous segment is done
    if (requiredPrevious.containsKey(_currentSegment)) {
      final prevSegment = requiredPrevious[_currentSegment]!;
      final prevTime = _participantRecordedTimes[participantId]?[prevSegment] ??
          Duration.zero;

      if (prevTime == Duration.zero) {
        throw Exception('Please finish $prevSegment first!');
      }
    }

    // Initialize participant record if first time
    _participantRecordedTimes.putIfAbsent(
        participantId,
        () => {
              'swim': Duration.zero,
              'cycle': Duration.zero,
              'run': Duration.zero,
            });

    final participantTimes = _participantRecordedTimes[participantId]!;

    Duration swimTime = participantTimes['swim'] ?? Duration.zero;
    Duration cycleTime = participantTimes['cycle'] ?? Duration.zero;

    Duration elapsed;

    if (_currentSegment == 'swim') {
      elapsed = globalElapsed;
    } else if (_currentSegment == 'cycle') {
      elapsed = globalElapsed - swimTime;
    } else if (_currentSegment == 'run') {
      elapsed = globalElapsed - swimTime - cycleTime;
    } else {
      elapsed = Duration.zero;
    }

    if (forceUpdate || participantTimes[_currentSegment] == Duration.zero) {
      participantTimes[_currentSegment] = elapsed;
      notifyListeners();
    }
  }

  Map<String, Duration> getParticipantSummary(String participantId) {
    return _participantRecordedTimes[participantId] ??
        {'swim': Duration.zero, 'cycle': Duration.zero, 'run': Duration.zero};
  }

  Duration getParticipantTotalTime(String participantId) {
    final times = _participantRecordedTimes[participantId];
    if (times == null) return Duration.zero;
    return times.values.fold(Duration.zero, (sum, t) => sum + t);
  }

  void resetAll() {
    _participantRecordedTimes.clear();
    _raceId = null;
    _raceName = null;
    notifyListeners();
  }
}
