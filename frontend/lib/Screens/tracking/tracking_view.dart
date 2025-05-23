import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rut/Screens/tracking/Widgets/search.dart';
import 'package:rut/controllers/race_controller.dart';
import 'package:rut/controllers/tracking_controller.dart';
import 'package:rut/services/participant_service.dart';

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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final race =
          Provider.of<RaceController>(context, listen: false).currentRace;
      if (race != null) {
        Provider.of<TrackingController>(context, listen: false)
            .setRace(race.id, race.name);
      }
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final raceController = Provider.of<RaceController>(context);
    final participantController = Provider.of<ParticipantService>(context);
    final trackingController = Provider.of<TrackingController>(context);

    final globalTime = raceController.elapsedTime;
    final isRaceRunning = raceController.currentRace?.status == 'Started';

    final allParticipants = participantController.participants;
    final filteredParticipants = _searchQuery.isEmpty
        ? allParticipants
        : allParticipants.where((p) {
            return p.name.toLowerCase().contains(_searchQuery) ||
                p.bibNumber.toLowerCase().contains(_searchQuery);
          }).toList();

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 3;
          if (constraints.maxWidth < 600) crossAxisCount = 2;
          if (constraints.maxWidth < 400) crossAxisCount = 1;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  "Global Time: ${formatDuration(globalTime)}",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // 🔍 Search widget
                SearchBarWidget(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim().toLowerCase();
                    });
                  },
                  isDarkMode: widget.isDarkMode,
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: ['swim', 'cycle', 'run'].map((segment) {
                    final isSelected =
                        trackingController.currentSegment == segment;
                    return ElevatedButton(
                      onPressed: () {
                        trackingController.setSegment(segment, globalTime);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.blue : Colors.grey,
                        minimumSize: const Size(90, 40),
                      ),
                      child: Text(segment.toUpperCase()),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: filteredParticipants.length,
                    itemBuilder: (context, index) {
                      final participant = filteredParticipants[index];
                      final summary = trackingController
                          .getParticipantSummary(participant.id);
                      final segTime =
                          summary[trackingController.currentSegment] ??
                              Duration.zero;
                      final hasRecorded = trackingController
                          .hasParticipantRecorded(participant.id);
                      final isExpanded = expandedIds.contains(participant.id);

                      return GestureDetector(
                        onTap: () {
                          if (isRaceRunning) {
                            try {
                              trackingController.recordParticipant(
                                participant.id,
                                globalTime,
                              );
                              setState(() {
                                isExpanded
                                    ? expandedIds.remove(participant.id)
                                    : expandedIds.add(participant.id);
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceAll('Exception: ', ''),
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Race is not running')),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: hasRecorded
                                ? Colors.blueAccent
                                : Colors.grey[300],
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
                                    color: hasRecorded
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                if (isExpanded) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    "${trackingController.currentSegment}: ${formatDuration(segTime)}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
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
          );
        },
      ),
    );
  }
}
