import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'screens/home_screen.dart';
import 'screens/tea_ready_screen.dart';
import 'screens/timer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const CayDemleApp());
}

class CayDemleApp extends StatefulWidget {
  const CayDemleApp({super.key});

  @override
  State<CayDemleApp> createState() => _CayDemleAppState();
}

class _CayDemleAppState extends State<CayDemleApp> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Çay Demle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB22222),
          brightness: Brightness.light,
          primary: const Color(0xFF8B0000),
          secondary: const Color(0xFFC41E3A),
          surface: const Color(0xFFFFF0F0),
        ),
        useMaterial3: true,
        fontFamily: 'Georgia',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Color(0xFF8B0000)),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/timer': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final brewTime = args?['brewTime'] as DateTime? ?? DateTime.now();
          final durationMinutes = args?['durationMinutes'] as int? ?? defaultDurationMinutes;
          return TimerScreen(brewTime: brewTime, durationMinutes: durationMinutes);
        },
        '/tea-ready': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final brewTime = args?['brewTime'] as DateTime? ?? DateTime.now();
          return TeaReadyScreen(brewTime: brewTime);
        },
      },
    );
  }
}
