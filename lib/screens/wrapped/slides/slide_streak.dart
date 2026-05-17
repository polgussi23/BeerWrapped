// screens/wrapped/slides/slide_streak.dart
import 'package:flutter/material.dart';

class SlideStreak extends StatefulWidget {
  final Map<String, dynamic> data;

  const SlideStreak({Key? key, required this.data}) : super(key: key);

  @override
  _SlideStreakState createState() => _SlideStreakState();
}

class _SlideStreakState extends State<SlideStreak>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _countAnim;

  @override
  void initState() {
    super.initState();
    final streak = widget.data['maxStreak'] as int;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _countAnim = IntTween(begin: 0, end: streak).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getPhrase(int streak) {
    if (streak >= 7) return 'Una setmana sencera! Increïble 🔥';
    if (streak >= 4) return 'Quasi una setmana seguida! 💪';
    if (streak >= 2) return 'Uns quants dies seguits!';
    return 'Un dia és un dia!';
  }

  @override
  Widget build(BuildContext context) {
    final streak = widget.data['maxStreak'] as int;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E0A0A), Color(0xFF6E1F1F)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              const Text(
                'La teva ratxa màxima',
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 22,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedBuilder(
                animation: _countAnim,
                builder: (context, child) => Text(
                  '${_countAnim.value}',
                  style: const TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Text(
                'dies consecutius',
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 28,
                  color: Color(0xFFB5884C),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getPhrase(streak),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 18,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
