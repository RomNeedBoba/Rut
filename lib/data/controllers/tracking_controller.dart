import 'package:flutter/material.dart';
import '../models/tracking_model.dart';

class TrackingController with ChangeNotifier {
  List<SegmentTime> _segmentTimes = [];
  String _currentSegment = 'swim';

  List<SegmentTime> get segmentTimes => _segmentTimes;
  String get currentSegment => _currentSegment;

  void setSegment(String segment) {
    _currentSegment = segment;
    notifyListeners();
  }

  void addSegmentTime(SegmentTime time) {
    _segmentTimes.add(time);
    notifyListeners();
  }

  void removeSegmentTime(String participantId, String segment) {
    _segmentTimes.removeWhere((t) =>
        t.participantId == participantId && t.segment == segment);
    notifyListeners();
  }
}
