import 'package:birrawrapped/models/wrapped_data.dart';
import 'package:flutter/material.dart';

class SlideHighlights extends StatefulWidget {
  final WrappedData data;
  const SlideHighlights({Key? key, required this.data}) : super(key: key);

  @override
  _SlideHighlightsState createState() => _SlideHighlightsState();
}

class _SlideHighlightsState extends State<SlideHighlights>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.data.highlights.length) return;
    _controller.reverse().then((_) {
      setState(() => _current = index);
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final highlights = widget.data.highlights;
    if (highlights.isEmpty) return const SizedBox();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1208), Color(0xFF3D2D0A)],
        ),
      ),
      child: GestureDetector(
        // El tap dret/esquerre aquí fa navegar entre highlights,
        // no entre slides — cal capturar-ho abans que el wrapped_screen
        onTapUp: (details) {
          final half = MediaQuery.of(context).size.width / 2;
          if (details.globalPosition.dx > half) {
            if (_current < highlights.length - 1) {
              _goTo(_current + 1);
            }
            // Si és l'últim highlight, el tap passarà al wrapped_screen
            // i anirà a la slide següent — comportament correcte
          } else {
            if (_current > 0) {
              _goTo(_current - 1);
            }
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('✨', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Text(
                    '"${highlights[_current]}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Kameron',
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    highlights.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _current ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _current
                            ? const Color(0xFFB5884C)
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _current < highlights.length - 1
                      ? 'Toca la dreta per veure més'
                      : 'Toca la dreta per continuar',
                  style: const TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 13,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
