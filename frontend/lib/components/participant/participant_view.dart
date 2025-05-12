import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/controllers/participant_controller.dart';
import '../../data/models/participant_model.dart';

class ParticipantView extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ParticipantView({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final participantController = Provider.of<ParticipantController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Participants'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: VerticalDivider(
              color: Colors.white,
              thickness: 1,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddParticipantDialog(),
              );
            },
          ),
        ],
      ),
      body: participantController.participants.isEmpty
          ? const Center(child: Text('No participants added yet.'))
          : ListView.builder(
              itemCount: participantController.participants.length,
              itemBuilder: (context, index) {
                final participant = participantController.participants[index];
                return ListTile(
                  title: Row(
                    children: [
                      Text(participant.bibNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Text('|'),
                      const SizedBox(width: 8),
                      Expanded(child: Text(participant.name)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      participantController.removeParticipant(participant.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}

class AddParticipantDialog extends StatefulWidget {
  const AddParticipantDialog({Key? key}) : super(key: key);

  @override
  State<AddParticipantDialog> createState() => _AddParticipantDialogState();
}

class _AddParticipantDialogState extends State<AddParticipantDialog> {
  final _bibController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final participantController = Provider.of<ParticipantController>(context);

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
        TextButton(
          onPressed: () {
            if (_bibController.text.isNotEmpty &&
                _nameController.text.isNotEmpty) {
              final newParticipant = Participant(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                bibNumber: _bibController.text,
                name: _nameController.text,
              );
              participantController.addParticipant(newParticipant);
            }
            Navigator.of(context).pop();
          },
          child: const Text('ADD'),
        ),
      ],
    );
  }
}
