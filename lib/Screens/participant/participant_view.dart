import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rut/Screens/participant/widget/dialog.dart';
import '../../controllers/participant_controller.dart';


class ParticipantView extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ParticipantView({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<ParticipantView> createState() => _ParticipantViewState();
}

class _ParticipantViewState extends State<ParticipantView> {
  bool isLoading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  Future<void> _loadParticipants() async {
    setState(() => isLoading = true);
    try {
      await Provider.of<ParticipantController>(context, listen: false)
          .loadParticipants();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading participants: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final participantController = Provider.of<ParticipantController>(context);
    final filteredParticipants =
        participantController.participants.where((participant) {
      final query = searchQuery.toLowerCase();
      return participant.bibNumber.toLowerCase().contains(query) ||
          participant.name.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Participants'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadParticipants,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by BIB or name...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: widget.isDarkMode ? Colors.black12 : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredParticipants.isEmpty
              ? const Center(child: Text('No participants found.'))
              : ListView.builder(
                  itemCount: filteredParticipants.length,
                  itemBuilder: (context, index) {
                    final participant = filteredParticipants[index];
                    return ListTile(
                      title: Row(
                        children: [
                          Text(participant.bibNumber,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Text('|'),
                          const SizedBox(width: 8),
                          Expanded(child: Text(participant.name)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await participantController
                                .removeParticipant(participant.id);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Error deleting participant: $e')),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
