// screens/wrapped/slides/slide_best_group.dart
import 'package:flutter/material.dart';

class SlideBestGroup extends StatelessWidget {
  final Map<String, dynamic> data;

  const SlideBestGroup({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bestGroup = data['bestGroup'];

    if (bestGroup == null) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF2E2E2E)],
          ),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('😔', style: TextStyle(fontSize: 80)),
                SizedBox(height: 24),
                Text(
                  'Encara no formes part de cap grup',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'L\'any que ve, convida els teus amics!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 18,
                    color: Colors.white60,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final name = bestGroup['name'] as String;
    final count = bestGroup['count'];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A2A1A), Color(0xFF1A4A2E)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('👥', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              const Text(
                'El teu grup més actiu',
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 22,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                  '$count birres compartides amb aquest grup 🍻',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aquests sí que són amics de veritat!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 16,
                  color: Colors.white60,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
