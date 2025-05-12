import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ResultView({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: const Center(
        child: Text('Results Screen'),
      ),
    );
  }
}
