import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rut/controllers/race_controller.dart';
import 'package:rut/controllers/participant_controller.dart';
import 'package:rut/controllers/tracking_controller.dart';

class TrackingView extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const TrackingView({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<TrackingView> {
  final Set<String> expandedIds = {};

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final raceController = Provider.of<RaceController>(context);
    final participantController = Provider.of<ParticipantController>(context);
    final trackingController = Provider.of<TrackingController>(context);

    final globalTime = raceController.elapsedTime;
    final isRaceRunning = raceController.currentRace?.status == 'Started';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Race Tracking'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              "Global Time: ${formatDuration(globalTime)}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['swim', 'cycle', 'run'].map((segment) {
                final isSelected = trackingController.currentSegment == segment;
                return ElevatedButton(
                  onPressed: () {
                    trackingController.setSegment(segment, globalTime);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.blue : Colors.grey,
                  ),
                  child: Text(segment.toUpperCase()),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: participantController.participants.length,
                itemBuilder: (context, index) {
                  final participant = participantController.participants[index];
                  final summary = trackingController.getParticipantSummary(participant.id);
                  final segTime = summary[trackingController.currentSegment] ?? Duration.zero;
                  final hasRecorded = trackingController.hasParticipantRecorded(participant.id);
                  final isExpanded = expandedIds.contains(participant.id);

                  return GestureDetector(
                    onTap: () {
                      if (isRaceRunning) {
                        trackingController.recordParticipant(participant.id, globalTime);
                        setState(() {
                          if (isExpanded) {
                            expandedIds.remove(participant.id);
                          } else {
                            expandedIds.add(participant.id);
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Race is not running')),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: hasRecorded ? Colors.blueAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: hasRecorded
                            ? [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              participant.bibNumber,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: hasRecorded ? Colors.white : Colors.black,
                              ),
                            ),
                            if (isExpanded) ...[
                              const SizedBox(height: 4),
                              Text(
                                "${trackingController.currentSegment}: ${formatDuration(segTime)}",
                                style: const TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
