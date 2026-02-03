import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  final DateTime brewTime;
  final int durationMinutes;

  const TimerScreen({super.key, required this.brewTime, this.durationMinutes = 20});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.durationMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _startTimer();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 0) {
        t.cancel();
        _onTimerComplete();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  Future<void> _onTimerComplete() async {
    await _playAlarmTwice();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      '/tea-ready',
      arguments: {'brewTime': widget.brewTime},
    );
  }

  Future<void> _playAlarmTwice() async {
    final completer = Completer<void>();
    var playCount = 0;
    void onComplete() {
      playCount++;
      if (playCount >= 2) {
        _audioPlayer.stop();
        if (!completer.isCompleted) completer.complete();
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.resume();
      }
    }

    final sub = _audioPlayer.onPlayerComplete.listen((_) => onComplete());
    try {
      await _audioPlayer.play(AssetSource('caylar.mpeg'));
    } catch (_) {
      try {
        await _audioPlayer.play(AssetSource('cayhazir.mp3'));
      } catch (e) {
        debugPrint('Ses çalınamadı: $e');
        if (!completer.isCompleted) completer.complete();
        return;
      }
    }
    await completer.future;
    await sub.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF0F0),
              Color(0xFFFFE4E1),
              Color(0xFFF5C6C6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/cay.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.local_cafe_rounded, size: 64, color: Colors.red.shade400),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'ÇAYIN HAZIR OLMASINA SON:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      _formattedTime,
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B0000),
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${(_remainingSeconds / 60).ceil()} dakika kaldı',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextButton.icon(
                    onPressed: _cancelTimer,
                    icon: Icon(Icons.cancel_outlined, size: 20, color: Colors.red.shade700),
                    label: Text(
                      'Sayacı iptal et',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade900,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      backgroundColor: Colors.white.withOpacity(0.7),
                      foregroundColor: Colors.red.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
