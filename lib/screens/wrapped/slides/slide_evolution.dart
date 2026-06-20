import 'package:birrawrapped/models/wrapped_data.dart';
import 'package:flutter/material.dart';

class SlideEvolution extends StatefulWidget {
  final WrappedData data;
  const SlideEvolution({Key? key, required this.data}) : super(key: key);

  @override
  _SlideEvolutionState createState() => _SlideEvolutionState();
}

class _SlideEvolutionState extends State<SlideEvolution>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _barAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _barAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isUp = d.trend == 'up';
    final total = d.firstHalf + d.secondHalf;
    final firstRatio = total == 0 ? 0.5 : d.firstHalf / total;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isUp
              ? [const Color(0xFF0A2E0A), const Color(0xFF1F6E1F)]
              : [const Color(0xFF2E1A0A), const Color(0xFF6E3D1F)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isUp ? '📈' : '📉', style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                isUp ? 'Vas en augment!' : 'Vas a la baixa',
                style: const TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isUp
                    ? 'El segon semestre has begut més'
                    : 'El primer semestre has begut més',
                style: const TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 40),
              // Barres comparatives
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _bar('1r sem.', d.firstHalf, firstRatio,
                      const Color(0xFFB5884C), _barAnim),
                  const SizedBox(width: 24),
                  _bar(
                      '2n sem.',
                      d.secondHalf,
                      1 - firstRatio,
                      isUp ? Colors.greenAccent.shade400 : Colors.white54,
                      _barAnim),
                ],
              ),
              const SizedBox(height: 32),
              if (d.bestSeason != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Millor estació: ${d.bestSeason} amb ${d.bestSeasonCount} birres',
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

  Widget _bar(String label, int count, double ratio, Color color,
      Animation<double> anim) {
    const maxHeight = 140.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontFamily: 'Kameron',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedBuilder(
          animation: anim,
          builder: (_, __) => Container(
            width: 80,
            height: maxHeight * ratio.clamp(0.1, 1.0) * anim.value,
            decoration: BoxDecoration(
              color: color.withOpacity(0.85),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Kameron',
            fontSize: 14,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}
