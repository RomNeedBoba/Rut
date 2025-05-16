import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rut/models/participant_model.dart';
import 'package:rut/services/participant_service.dart';

class ParticipantDialog extends StatefulWidget {
  final Participant? participant;

  const ParticipantDialog({super.key, this.participant});

  @override
  State<ParticipantDialog> createState() => _ParticipantDialogState();
}

class _ParticipantDialogState extends State<ParticipantDialog> {
  late TextEditingController _bibController;
  late TextEditingController _nameController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _bibController =
        TextEditingController(text: widget.participant?.bibNumber ?? '');
    _nameController =
        TextEditingController(text: widget.participant?.name ?? '');
  }

  @override
  void dispose() {
    _bibController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final participantService =
        Provider.of<ParticipantService>(context, listen: false);
    final isEdit = widget.participant != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Participant' : 'Add Participant'),
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
                  final bib = _bibController.text.trim();
                  final name = _nameController.text.trim();

                  if (bib.isEmpty || name.isEmpty) return;

                  setState(() => isSaving = true);

                  try {
                    if (isEdit) {
                      await participantService.updateParticipant(
                        Participant(
                          id: widget.participant!.id,
                          bibNumber: bib,
                          name: name,
                        ),
                      );
                    } else {
                      await participantService.addParticipant(
                        Participant(
                          id: '',
                          bibNumber: bib,
                          name: name,
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  } finally {
                    setState(() => isSaving = false);
                  }
                },
                child: Text(isEdit ? 'UPDATE' : 'ADD'),
              ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}
