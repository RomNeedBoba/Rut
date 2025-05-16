import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/participant_model.dart';

class ParticipantService with ChangeNotifier {
  final String baseUrl = 'https://rut-backend.onrender.com';

  List<Participant> _participants = [];
  List<Participant> get participants => _participants;

  /// Load all participants from the backend
  Future<void> loadParticipants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/participants'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _participants = data.map((e) => Participant.fromJson(e)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load participants');
      }
    } catch (e) {
      throw Exception('Error loading participants: $e');
    }
  }

  /// Add a new participant
  Future<void> addParticipant(Participant participant) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/participants'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(participant.toJson(includeId: false)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final added = Participant.fromJson(jsonDecode(response.body));
        _participants.insert(0, added);
        notifyListeners();
      } else {
        throw Exception('Failed to add participant: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding participant: $e');
    }
  }

  /// Delete a participant by ID
  Future<void> removeParticipant(String id) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/participants/$id'));

      if (response.statusCode == 200) {
        _participants.removeWhere((p) => p.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to delete participant: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting participant: $e');
    }
  }

  /// Update a participant by ID
  Future<void> updateParticipant(Participant updated) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/participants/${updated.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updated.toJson(includeId: false)),
      );

      if (response.statusCode == 200) {
        final newData = Participant.fromJson(jsonDecode(response.body));
        final index = _participants.indexWhere((p) => p.id == updated.id);
        if (index != -1) {
          _participants[index] = newData;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update participant: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating participant: $e');
    }
  }
}
