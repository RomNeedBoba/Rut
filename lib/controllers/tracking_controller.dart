import 'package:flutter/material.dart';

class TrackingController with ChangeNotifier {
  String _currentSegment = 'swim'; // 'swim', 'cycle', or 'run'

  final Map<String, Duration> _segmentStartPoints = {
    'swim': Duration.zero,
    'cycle': Duration.zero,
    'run': Duration.zero,
  };

  final Map<String, Map<String, Duration>> _participantRecordedTimes =
      {}; // segment times
  final Map<String, Duration> _participantFinalGlobalTimes =
      {}; // final global time

  String get currentSegment => _currentSegment;

  void setSegment(String segment, Duration globalElapsed) {
    _currentSegment = segment;

    if (_segmentStartPoints[segment] == Duration.zero) {
      _segmentStartPoints[segment] = globalElapsed;
    }

    notifyListeners();
  }

  /// Check if participant has recorded in current segment
  bool hasParticipantRecorded(String participantId) {
    return (_participantRecordedTimes[participantId]?[_currentSegment] ??
            Duration.zero) !=
        Duration.zero;
  }

  /// Record participant’s segment time
  void recordParticipant(String participantId, Duration globalElapsed,
      {bool forceUpdate = false}) {
    final requiredPrevious = {
      'cycle': 'swim',
      'run': 'cycle',
    };

    if (requiredPrevious.containsKey(_currentSegment)) {
      final prevSegment = requiredPrevious[_currentSegment]!;
      final prevTime = _participantRecordedTimes[participantId]?[prevSegment] ??
          Duration.zero;
      if (prevTime == Duration.zero) {
        return; // skip if previous not done
      }
    }

    _participantRecordedTimes.putIfAbsent(
        participantId,
        () => {
              'swim': Duration.zero,
              'cycle': Duration.zero,
              'run': Duration.zero,
            });

    final segmentStart = _segmentStartPoints[_currentSegment] ?? Duration.zero;
    final elapsedInSegment = globalElapsed - segmentStart;

    if (forceUpdate ||
        _participantRecordedTimes[participantId]![_currentSegment] ==
            Duration.zero) {
      _participantRecordedTimes[participantId]![_currentSegment] =
          elapsedInSegment;
      notifyListeners();
    }
  }

  /// Get all segment times for a participant
  Map<String, Duration> getParticipantSummary(String participantId) {
    return _participantRecordedTimes[participantId] ??
        {
          'swim': Duration.zero,
          'cycle': Duration.zero,
          'run': Duration.zero,
        };
  }

  /// Get total combined segment time
  Duration getParticipantTotalTime(String participantId) {
    final times = _participantRecordedTimes[participantId];
    if (times == null) return Duration.zero;
    return times.values.fold(Duration.zero, (sum, t) => sum + t);
  }

  /// Save participant’s final global time (from race clock)
  void saveParticipantFinalGlobalTime(
      String participantId, Duration globalElapsed) {
    _participantFinalGlobalTimes[participantId] = globalElapsed;
    notifyListeners();
  }

  /// Get participant’s final global time (if saved) or live race time
  Duration getParticipantFinalGlobalTime(
      String participantId, Duration globalElapsed) {
    return _participantFinalGlobalTimes[participantId] ?? globalElapsed;
  }

  /// Reset everything
  void resetAll() {
    _segmentStartPoints.updateAll((key, value) => Duration.zero);
    _participantRecordedTimes.clear();
    _participantFinalGlobalTimes.clear();
    notifyListeners();
  }
}
