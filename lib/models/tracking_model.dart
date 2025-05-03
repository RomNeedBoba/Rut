class SegmentTime {
  final String participantId;
  final String segment; // swim, cycle, run
  final Duration time;

  SegmentTime({
    required this.participantId,
    required this.segment,
    required this.time,
  });

  factory SegmentTime.fromJson(Map<String, dynamic> json) {
    return SegmentTime(
      participantId: json['participantId'],
      segment: json['segment'],
      time: Duration(seconds: json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': participantId,
      'segment': segment,
      'time': time.inSeconds,
    };
  }
}
