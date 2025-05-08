import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rut/controllers/participant_controller.dart';
import 'package:rut/models/participant_model.dart';

class AddParticipantDialog extends StatefulWidget {
  const AddParticipantDialog({super.key});

  @override
  State<AddParticipantDialog> createState() => _AddParticipantDialogState();
}

class _AddParticipantDialogState extends State<AddParticipantDialog> {
  final _bibController = TextEditingController();
  final _nameController = TextEditingController();
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    final participantController = Provider.of<ParticipantController>(context, listen: false);

    return AlertDialog(
      title: const Text('Add Participant'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _bibController,
            decoration: const InputDecoration(labelText: 'BIB Number'),
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
        ],
      ),
      actions: [
        isSaving
            ? const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : TextButton(
                onPressed: () async {
                  if (_bibController.text.isNotEmpty && _nameController.text.isNotEmpty) {
                    setState(() => isSaving = true);
                    try {
                      final newParticipant = Participant(
                        id: '', // let backend generate the ID
                        bibNumber: _bibController.text,
                        name: _nameController.text,
                      );
                      await participantController.addParticipant(newParticipant);
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error adding participant: $e')),
                      );
                    } finally {
                      setState(() => isSaving = false);
                    }
                  }
                },
                child: const Text('ADD'),
              ),
      ],
    );
  }
}
