class HistoryRace {
  final String id;
  final String raceName;
  final DateTime createdAt;
  final List<HistoryParticipant> results;

  HistoryRace({
    required this.id,
    required this.raceName,
    required this.createdAt,
    required this.results,
  });

  factory HistoryRace.fromJson(Map<String, dynamic> json) {
    return HistoryRace(
      id: json['_id'],
      raceName: json['raceName'],
      createdAt: DateTime.parse(json['createdAt']),
      results: (json['results'] as List)
          .map((e) => HistoryParticipant.fromJson(e))
          .toList(),
    );
  }
}

class HistoryParticipant {
  final String participantName;
  final String bibNumber;
  final int swimTime;
  final int cycleTime;
  final int runTime;
  final int totalTime;

  HistoryParticipant({
    required this.participantName,
    required this.bibNumber,
    required this.swimTime,
    required this.cycleTime,
    required this.runTime,
    required this.totalTime,
  });

  factory HistoryParticipant.fromJson(Map<String, dynamic> json) {
    return HistoryParticipant(
      participantName: json['participantName'],
      bibNumber: json['bibNumber'],
      swimTime: json['swimTime'],
      cycleTime: json['cycleTime'],
      runTime: json['runTime'],
      totalTime: json['totalTime'],
    );
  }
}
