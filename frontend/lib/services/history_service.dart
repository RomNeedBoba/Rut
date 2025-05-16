import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rut/models/historyRace_model.dart';

class HistoryService {
  final String baseUrl = 'https://rut-backend.onrender.com';

  Future<List<HistoryRace>> fetchHistory() async {
    final response = await http.get(Uri.parse('$baseUrl/races/history'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => HistoryRace.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load history');
    }
  }

  /// ✅ Delete a full race history by raceId
  Future<void> deleteRace(String raceId) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/races/history/$raceId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete race: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting race: $e');
    }
  }
}
