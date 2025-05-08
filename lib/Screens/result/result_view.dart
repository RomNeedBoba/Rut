import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/participant_controller.dart';
import '../../controllers/tracking_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    final participantController = Provider.of<ParticipantController>(context);
    final trackingController = Provider.of<TrackingController>(context);

    final participants = participantController.participants;

    // Sort participants by total time (fastest first)
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
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: isNarrow ? 600 : constraints.maxWidth),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Rank')),
                    DataColumn(label: Text('Athlete')),
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
                      if (index == 0) {
                        rankDisplay = '🥇';
                      } else if (index == 1)
                        rankDisplay = '🥈';
                      else if (index == 2) rankDisplay = '🥉';

                      return DataRow(
                        color: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            return index.isEven ? Colors.grey[100] : null;
                          },
                        ),
                        cells: [
                          DataCell(Text(rankDisplay)),
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
    );
  }
}
