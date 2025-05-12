class Result {
  final String participantId;
  final Duration totalTime;
  final Map<String, Duration> segmentTimes;

  Result({
    required this.participantId,
    required this.totalTime,
    required this.segmentTimes,
  });
}
