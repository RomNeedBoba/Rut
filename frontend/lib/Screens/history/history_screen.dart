import 'package:flutter/material.dart';
import 'package:rut/Screens/history/result_history.dart';
import 'package:rut/models/historyRace_model.dart';

import 'package:rut/services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryRace> _races = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => isLoading = true);
    try {
      _races = await HistoryService().fetchHistory();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to load history: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteRace(String raceId) async {
    try {
      await HistoryService()
          .deleteRace(raceId); // make sure this exists in service
      _fetchHistory(); // refresh
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to delete race: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Race History')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _races.isEmpty
              ? const Center(child: Text('No history found.'))
              : ListView.builder(
                  itemCount: _races.length,
                  itemBuilder: (context, index) {
                    final race = _races[index];
                    return ListTile(
                      title: Text(race.raceName),
                      subtitle: Text(
                        'Saved on: ${race.createdAt.toLocal().toString().split('.')[0]}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteRace(race.id),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HistoryResultView(race: race),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
