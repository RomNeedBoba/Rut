import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rut/services/participant_service.dart';
import '../../controllers/tracking_controller.dart';
import '../history/history_screen.dart';

class ResultView extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ResultView({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<void> pushStaticResults(BuildContext context, String raceName) async {
    final participantService =
        Provider.of<ParticipantService>(context, listen: false);
    final trackingController =
        Provider.of<TrackingController>(context, listen: false);

    final results = participantService.participants.map((participant) {
      final summary = trackingController.getParticipantSummary(participant.id);
      final swim = summary['swim']?.inSeconds ?? 0;
      final cycle = summary['cycle']?.inSeconds ?? 0;
      final run = summary['run']?.inSeconds ?? 0;
      final total = swim + cycle + run;

      return {
        "participantName": participant.name,
        "bibNumber": participant.bibNumber,
        "swimTime": swim,
        "cycleTime": cycle,
        "runTime": run,
        "totalTime": total,
      };
    }).toList();

    final body = {
      "raceName": raceName,
      "results": results,
    };

    print('📋 Race name entered: $raceName');
    print('📤 Sending results to backend...');
    print(jsonEncode(body));

    try {
      final response = await http.post(
        Uri.parse('https://rut-backend.onrender.com/races/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('✅ Response status: ${response.statusCode}');
      print('📨 Response body: ${response.body}');

      if (context.mounted) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Results saved to history')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ Failed: ${response.body}')),
          );
        }
      }
    } catch (e) {
      print('❌ HTTP error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e')),
        );
      }
    }
  }

  void showSaveDialog(BuildContext outerContext) {
    final nameController = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: outerContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Save Race Result'),
              content: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter Race Name',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final raceName = nameController.text.trim();
                          if (raceName.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('⚠️ Please enter a race name')),
                            );
                            return;
                          }

                          setState(() => isSaving = true);
                          await pushStaticResults(outerContext, raceName);
                          if (context.mounted) Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final participantController = Provider.of<ParticipantService>(context);
    final trackingController = Provider.of<TrackingController>(context);
    final participants = participantController.participants;

    final sortedParticipants = [...participants]..sort((a, b) {
        final timeA = trackingController.getParticipantTotalTime(a.id);
        final timeB = trackingController.getParticipantTotalTime(b.id);
        return timeA.compareTo(timeB);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Race Results'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View Race History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: isNarrow ? 600 : constraints.maxWidth,
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                          isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('Rank')),
                        DataColumn(label: Text('Athlete')),
                        DataColumn(label: Text('BIB Number')),
                        DataColumn(label: Text('Swimming')),
                        DataColumn(label: Text('Cycling')),
                        DataColumn(label: Text('Running')),
                        DataColumn(label: Text('Total')),
                      ],
                      rows: List<DataRow>.generate(
                        sortedParticipants.length,
                        (index) {
                          final participant = sortedParticipants[index];
                          final summary = trackingController
                              .getParticipantSummary(participant.id);
                          final swimTime = summary['swim'] ?? Duration.zero;
                          final cycleTime = summary['cycle'] ?? Duration.zero;
                          final runTime = summary['run'] ?? Duration.zero;
                          final totalTime = swimTime + cycleTime + runTime;

                          String rankDisplay = '${index + 1}';
                          if (index == 0)
                            rankDisplay = '🥇';
                          else if (index == 1)
                            rankDisplay = '🥈';
                          else if (index == 2) rankDisplay = '🥉';

                          return DataRow(
                            color: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                return index.isEven
                                    ? (isDarkMode
                                        ? Colors.grey[850]
                                        : Colors.grey[100])
                                    : null;
                              },
                            ),
                            cells: [
                              DataCell(Text(rankDisplay)),
                              DataCell(Text(participant.name)),
                              DataCell(Text('Bib ${participant.bibNumber}')),
                              DataCell(Text(formatDuration(swimTime))),
                              DataCell(Text(formatDuration(cycleTime))),
                              DataCell(Text(formatDuration(runTime))),
                              DataCell(Text(formatDuration(totalTime))),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Results to History'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
                onPressed: () => showSaveDialog(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
