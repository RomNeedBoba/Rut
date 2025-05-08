import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/participant_model.dart';

class ParticipantController with ChangeNotifier {
  final String baseUrl =
      'http://192.168.100.26:3000'; 

  List<Participant> _participants = [];
  List<Participant> get participants => _participants;

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

  // Add participant to backend + local list
  Future<void> addParticipant(Participant participant) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/participants'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(participant.toJson()),
      );
      if (response.statusCode == 200) {
        final added = Participant.fromJson(jsonDecode(response.body));
        _participants.add(added);
        notifyListeners();
      } else {
        throw Exception('Failed to add participant');
      }
    } catch (e) {
      throw Exception('Error adding participant: $e');
    }
  }

  // Remove participant from backend + local list
  Future<void> removeParticipant(String id) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/participants/$id'));
      if (response.statusCode == 200) {
        _participants.removeWhere((p) => p.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to delete participant');
      }
    } catch (e) {
      throw Exception('Error deleting participant: $e');
    }
  }

  // Update participant locally (optional, backend update can be added if needed)
  Future<void> updateParticipant(Participant updated) async {
    int index = _participants.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _participants[index] = updated;
      notifyListeners();
    }
  }
}
