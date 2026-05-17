// screens/wrapped/slides/slide_intro.dart
import 'package:flutter/material.dart';

class SlideIntro extends StatelessWidget {
  final VoidCallback onStart;

  const SlideIntro({Key? key, required this.onStart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A0A00), Color(0xFF3D1F00)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🍺', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            const Text(
              'El teu any\nen birres',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Prepara\'t per descobrir\ncom ha anat l\'any',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 18,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: onStart,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFB5884C),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Comencem! 🍻',
                  style: TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
