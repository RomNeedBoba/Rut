import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/race_controller.dart';
import '../../controllers/tracking_controller.dart';
import '../../models/race_model.dart';

class RaceView extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const RaceView({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final raceController = Provider.of<RaceController>(context);
    final trackingController = Provider.of<TrackingController>(context, listen: false);

    // AUTO-SET DEFAULT RACE IF NONE EXISTS
    if (raceController.currentRace == null) {
      final newRace = Race(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Annual Triathlon',
        dateTime: DateTime.now(),
        status: 'Not Started',
      );
      raceController.setRace(newRace);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Race Control'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🏁 Current Race',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      raceController.currentRace!.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${raceController.currentRace!.status}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Elapsed Time: ${raceController.elapsedTime.inMinutes}:${(raceController.elapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '⚙️ Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  onPressed: () {
                    raceController.startRace();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.flag),
                  label: const Text('Finish'),
                  onPressed: () {
                    raceController.stopRace();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  onPressed: () {
                    raceController.resetRace();
                    trackingController.resetAll();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Race and tracking data have been reset'),
                        backgroundColor: Colors.grey[800],
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
