class Participant {
  final String id;
  final String bibNumber;
  final String name;

  Participant({
    required this.id,
    required this.bibNumber,
    required this.name,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] ?? '',
      bibNumber: json['bibNumber'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final data = {
      'bibNumber': bibNumber,
      'name': name,
    };
    if (includeId && id.isNotEmpty) {
      data['_id'] = id;
    }
    return data;
  }
}
