import 'package:flutter/material.dart';

/// Sayaç süresi 5-30 dakika arası seçilebilir.
const int minDurationMinutes = 5;
const int maxDurationMinutes = 30;
const int defaultDurationMinutes = 20;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _durationMinutes = defaultDurationMinutes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                    borderRadius: BorderRadius.circular(80),
                    child: Image.asset(
                      'assets/cay.jpg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.local_cafe_rounded,
                        size: 100,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Çay Demle',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Sayaç süresini değiştir
                  Text(
                    'Sayaç süresi',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_outlined, size: 20, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: _durationMinutes,
                        underline: const SizedBox(),
                        items: List.generate(
                          maxDurationMinutes - minDurationMinutes + 1,
                          (i) => minDurationMinutes + i,
                        ).map((m) => DropdownMenuItem(value: m, child: Text('$m dakika'))).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _durationMinutes = v);
                        },
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _TeaButton(
                    label: 'ÇAY DEMLEDİM',
                    onPressed: () {
                      final now = DateTime.now();
                      Navigator.pushNamed(
                        context,
                        '/timer',
                        arguments: {'brewTime': now, 'durationMinutes': _durationMinutes},
                      );
                    },
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

class _TeaButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _TeaButton({required this.label, required this.onPressed});

  @override
  State<_TeaButton> createState() => _TeaButtonState();
}

class _TeaButtonState extends State<_TeaButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFC41E3A),
                Color(0xFFB22222),
                Color(0xFF8B0000),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.red.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_cafe_rounded, color: Colors.white.withOpacity(0.9), size: 32),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
