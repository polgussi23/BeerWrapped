// screens/wrapped/slides/slide_total_beers.dart
import 'package:flutter/material.dart';

class SlideTotalBeers extends StatefulWidget {
  final Map<String, dynamic> data;

  const SlideTotalBeers({Key? key, required this.data}) : super(key: key);

  @override
  _SlideTotalBeersState createState() => _SlideTotalBeersState();
}

class _SlideTotalBeersState extends State<SlideTotalBeers>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _countAnim;

  @override
  void initState() {
    super.initState();
    final total = widget.data['totals']['totalBeers'] as int;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _countAnim = IntTween(begin: 0, end: total).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalLiters = widget.data['totals']['totalLiters'];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Aquest any has begut',
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 22,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 16),
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
              'birres',
              style: TextStyle(
                fontFamily: 'Kameron',
                fontSize: 36,
                color: Color(0xFFB5884C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Equivalent a $totalLiters litres 🍺',
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
    );
  }
}
