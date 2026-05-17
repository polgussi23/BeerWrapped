// screens/wrapped/slides/slide_fav_beer.dart
import 'package:flutter/material.dart';

class SlideFavBeer extends StatelessWidget {
  final Map<String, dynamic> data;

  const SlideFavBeer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favBeer = data['favBeer'];
    final name = favBeer['name'] as String;
    final percentage = favBeer['percentage'];
    final count = favBeer['count'];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A2E1A), Color(0xFF1A5C34)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'La teva birra preferida',
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 22,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 24),
            const Text('🏆', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              name.substring(0, 1).toUpperCase() + name.substring(1),
              style: const TextStyle(
                fontFamily: 'Kameron',
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$count vegades · $percentage% de les teves birres',
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
    );
  }
}
