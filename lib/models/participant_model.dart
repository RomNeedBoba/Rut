class Participant {
  final String id; // used for backend ID, not bib num okkay bro rith
  final String bibNumber;
  final String name;

  Participant({
    required this.id,
    required this.bibNumber,
    required this.name,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'],
      bibNumber: json['bibNumber'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bibNumber': bibNumber,
      'name': name,
    };
  }
}
