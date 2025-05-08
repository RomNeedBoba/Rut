import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../participant/participant_view.dart';
import '../race/race_view.dart';
import '../tracking/tracking_view.dart';
import '../result/result_view.dart';

class MainShell extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const MainShell({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      ParticipantView(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
      RaceView(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
      TrackingView(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
      ResultView(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.people),
            title: const Text("Participants"),
            selectedColor: Colors.blueAccent,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.flag),
            title: const Text("Race"),
            selectedColor: Colors.redAccent,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.timer),
            title: const Text("Tracking"),
            selectedColor: Colors.orangeAccent,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.emoji_events),
            title: const Text("Results"),
            selectedColor: Colors.greenAccent,
          ),
        ],
      ),
    );
  }
}
