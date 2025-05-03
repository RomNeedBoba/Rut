import 'package:flutter/material.dart';
import '../models/participant_model.dart';

class ParticipantController with ChangeNotifier {
  List<Participant> _participants = [];

  List<Participant> get participants => _participants;

  void setParticipants(List<Participant> list) {
    _participants = list;
    notifyListeners();
  }

  void addParticipant(Participant participant) {
    _participants.add(participant);
    notifyListeners();
  }

  void removeParticipant(String id) {
    _participants.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void updateParticipant(Participant updated) {
    int index = _participants.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _participants[index] = updated;
      notifyListeners();
    }
  }
}
