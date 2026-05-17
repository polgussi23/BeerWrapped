// screens/wrapped/slides/slide_best_day.dart
import 'package:flutter/material.dart';

class SlideBestDay extends StatelessWidget {
  final Map<String, dynamic> data;

  const SlideBestDay({Key? key, required this.data}) : super(key: key);

  String _getEmoji(String day) {
    switch (day.toLowerCase()) {
      case 'dilluns':
        return '😩';
      case 'dimarts':
        return '😐';
      case 'dimecres':
        return '🙂';
      case 'dijous':
        return '😄';
      case 'divendres':
        return '🤩';
      case 'dissabte':
        return '🥳';
      case 'diumenge':
        return '😎';
      default:
        return '🍺';
    }
  }

  String _getPhrase(String day) {
    switch (day.toLowerCase()) {
      case 'dilluns':
        return 'Clarament no suportes els dilluns...';
      case 'dimarts':
        return 'Els dimarts tampoc se\'t fan llargs!';
      case 'dimecres':
        return 'Ja a meitat de setmana, ja!';
      case 'dijous':
        return 'El dijous és el nou divendres!';
      case 'divendres':
        return 'Ets un animal dels divendres!';
      case 'dissabte':
        return 'El dissabte és sagrat per a tu!';
      case 'diumenge':
        return 'Fins i tot el diumenge t\'hi poses!';
      default:
        return 'Tens molt de gust!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bestDay = data['bestDayOfWeek'];
    final day = bestDay['day'] as String;
    final count = bestDay['count'];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A0A2E), Color(0xFF3D1F6E)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getEmoji(day),
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 24),
              const Text(
                'El teu dia preferit',
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 22,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                day,
                style: const TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _getPhrase(day),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 20,
                  color: Color(0xFFB5884C),
                  fontStyle: FontStyle.italic,
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
                  '$count birres en $day aquest any',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 16,
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
