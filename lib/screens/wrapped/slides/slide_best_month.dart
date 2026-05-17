// screens/wrapped/slides/slide_best_month.dart
import 'package:flutter/material.dart';

class SlideBestMonth extends StatelessWidget {
  final Map<String, dynamic> data;

  const SlideBestMonth({Key? key, required this.data}) : super(key: key);

  static const _months = [
    '',
    'gener',
    'febrer',
    'març',
    'abril',
    'maig',
    'juny',
    'juliol',
    'agost',
    'setembre',
    'octubre',
    'novembre',
    'desembre'
  ];

  String _getEmoji(int month) {
    switch (month) {
      case 12:
      case 1:
      case 2:
        return '❄️';
      case 3:
      case 4:
      case 5:
        return '🌸';
      case 6:
      case 7:
      case 8:
        return '☀️';
      default:
        return '🍂';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bestMonth = data['bestMonth'];
    final month = bestMonth['month'] as int;
    final year = bestMonth['year'];
    final count = bestMonth['count'];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A0A), Color(0xFF4A4A00)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getEmoji(month),
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 24),
              const Text(
                'El teu millor mes',
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 22,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${_months[month].substring(0, 1).toUpperCase()}${_months[month].substring(1)}',
                style: const TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '$year',
                style: const TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 24,
                  color: Colors.white38,
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
                  '$count birres en un sol mes 🔥',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 18,
                    color: Colors.white,
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
