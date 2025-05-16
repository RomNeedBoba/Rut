import 'package:flutter/material.dart';
import 'package:rut/models/race_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Race>> _races;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Races')),
      body: FutureBuilder<List<Race>>(
        future: _races,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No races available.'));
          }
          final races = snapshot.data!;
          return ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) {
              final race = races[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(race.name),
                  subtitle: Text(
                      'Status: ${race.status}\nDate: ${race.dateTime.toLocal()}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // You can later add navigation here
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add Race form later
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
