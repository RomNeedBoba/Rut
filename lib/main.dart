import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rut/controllers/result_controller.dart';
import 'package:rut/controllers/tracking_controller.dart';
import 'theme/app_theme.dart';
import 'controllers/participant_controller.dart';
import 'controllers/race_controller.dart';
import 'Screens/shared/main_shell.dart';

void main() {
  runApp(const RaceApp());
}

class RaceApp extends StatefulWidget {
  const RaceApp({super.key});

  @override
  State<RaceApp> createState() => _RaceAppState();
}

class _RaceAppState extends State<RaceApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParticipantController()),
        ChangeNotifierProvider(create: (_) => RaceController()),
        ChangeNotifierProvider(create: (_) => TrackingController()),
        ChangeNotifierProvider(create: (_) => ResultController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Race Tracker',
        theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        home: MainShell(
          isDarkMode: _isDarkMode,
          toggleTheme: _toggleTheme,
        ),
      ),
    );
  }
}
