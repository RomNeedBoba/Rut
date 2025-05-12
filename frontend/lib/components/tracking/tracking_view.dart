import 'package:flutter/material.dart';

class TrackingView extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const TrackingView({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracking'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: const Center(
        child: Text('Tracking Screen'),
      ),
    );
  }
}
