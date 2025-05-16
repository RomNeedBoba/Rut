class Result {
  final String id;
  final String raceId;
  final String raceName;
  final String participantId;
  final String participantName;
  final String bibNumber;

  final int swimTime;
  final int cycleTime;
  final int runTime;
  final int totalTime;

  Result({
    required this.id,
    required this.raceId,
    required this.raceName,
    required this.participantId,
    required this.participantName,
    required this.bibNumber,
    required this.swimTime,
    required this.cycleTime,
    required this.runTime,
    required this.totalTime,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['_id'],
      raceId: json['raceId'],
      raceName: json['raceName'],
      participantId: json['participantId'],
      participantName: json['participantName'],
      bibNumber: json['bibNumber'],
      swimTime: json['swimTime'],
      cycleTime: json['cycleTime'],
      runTime: json['runTime'],
      totalTime: json['totalTime'],
    );
  }
}
