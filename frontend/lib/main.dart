import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:rut/controllers/result_controller.dart';
import 'package:rut/controllers/tracking_controller.dart';
import 'package:rut/controllers/race_controller.dart';
import 'package:rut/Screens/shared/main_shell.dart';
import 'package:rut/services/participant_service.dart';
import 'theme/app_theme.dart';

const String backendUrl = 'https://rut-backend.onrender.com';

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
  bool _backendConnected = true;

  @override
  void initState() {
    super.initState();
    _checkBackendConnection();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Future<void> _checkBackendConnection() async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/ping'));
      if (response.statusCode == 200) {
        print('✅ Connected to backend!');
      } else {
        print('❌ Backend responded with error');
        setState(() => _backendConnected = false);
      }
    } catch (e) {
      print('❌ Error connecting to backend: $e');
      setState(() => _backendConnected = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ParticipantService()),
        ChangeNotifierProvider(create: (_) => RaceController()),
        ChangeNotifierProvider(create: (_) => TrackingController()),
        ChangeNotifierProvider(create: (_) => ResultController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Race Tracker',
        theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        home: Stack(
          children: [
            MainShell(
              isDarkMode: _isDarkMode,
              toggleTheme: _toggleTheme,
            ),
            if (!_backendConnected)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.red,
                  padding: const EdgeInsets.all(8),
                  child: const SafeArea(
                    child: Text(
                      '⚠ Cannot connect to backend',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
