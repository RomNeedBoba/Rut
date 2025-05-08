class Result {
  final String id;
  final String raceId;
  final String participantId;
  final int swimTime;
  final int cycleTime;
  final int runTime;
  final int totalTime;

  Result({
    required this.id,
    required this.raceId,
    required this.participantId,
    required this.swimTime,
    required this.cycleTime,
    required this.runTime,
    required this.totalTime,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['_id'],
      raceId: json['raceId'],
      participantId: json['participantId'],
      swimTime: json['swimTime'],
      cycleTime: json['cycleTime'],
      runTime: json['runTime'],
      totalTime: json['totalTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'raceId': raceId,
      'participantId': participantId,
      'swimTime': swimTime,
      'cycleTime': cycleTime,
      'runTime': runTime,
      'totalTime': totalTime,
    };
  }
}
