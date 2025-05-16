class Race {
  final String id;
  final String name;
  final DateTime dateTime;
  final String status;

  Race({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.status,
  });

  Race copyWith({
    String? id,
    String? name,
    DateTime? dateTime,
    String? status,
  }) {
    return Race(
      id: id ?? this.id,
      name: name ?? this.name,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
    );
  }

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      id: json['_id'],
      name: json['name'],
      dateTime: DateTime.parse(json['dateTime']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
    };
  }
}
