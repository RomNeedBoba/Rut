import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/controllers/race_controller.dart';
import '../../data/models/race_model.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: raceController.currentRace == null
            ? Center(
                child: ElevatedButton(
                  child: const Text('Set Current Race'),
                  onPressed: () {
                    final newRace = Race(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: 'Annual Triathlon',
                      dateTime: DateTime.now(),
                      status: 'Not Started',
                    );
                    raceController.setRace(newRace);
                  },
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Race: ${raceController.currentRace!.name}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Status: ${raceController.currentRace!.status}'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          raceController.startRace();
                        },
                        child: const Text('Start Race'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          raceController.stopRace();
                        },
                        child: const Text('Finish Race'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          raceController.resetRace();
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
