import 'package:flutter/material.dart';

class TrackingView extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const TrackingView({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

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
