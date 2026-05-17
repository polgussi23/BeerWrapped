// screens/wrapped/slides/slide_avg_time.dart
import 'package:flutter/material.dart';

class SlideAvgTime extends StatelessWidget {
  final Map<String, dynamic> data;

  const SlideAvgTime({Key? key, required this.data}) : super(key: key);

  String _getMoment(String time) {
    final hour = int.parse(time.split(':')[0]);
    if (hour >= 7 && hour < 12) return 'del matí 🌅';
    if (hour >= 12 && hour < 15) return 'del migdia ☀️';
    if (hour >= 15 && hour < 20) return 'de la tarda 🌤️';
    if (hour >= 20 && hour < 22) return 'del vespre 🌅';
    if (hour >= 22 || hour < 01) return 'de la nit 🌙';
    return 'de la matinada 🌃';
  }

  String _getPhrase(String time) {
    final hour = int.parse(time.split(':')[0]);
    if (hour >= 7 && hour < 12) return 'Comences aviat, eh?';
    if (hour >= 12 && hour < 15) return 'L\'aperitiu és sagrat!';
    if (hour >= 15 && hour < 20) return 'La tarda és el teu moment!';
    if (hour >= 20 && hour < 22) return 'La típica mentres sopes 😉';
    if (hour >= 22 || hour < 01) return 'Un clàssic de la nit!';
    return 'Ets un noctàmbul!';
  }

  @override
  Widget build(BuildContext context) {
    final avgTime = data['avgTime'] as String;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1A2E), Color(0xFF0A3D4A)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🕐', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              const Text(
                'Normalment comences a les',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 22,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                avgTime,
                style: const TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_getMoment(avgTime)}',
                style: const TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 24,
                  color: Color(0xFFB5884C),
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
                  _getPhrase(avgTime),
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
