import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';

class CustomTitle extends StatefulWidget { // Convert to StatefulWidget
  final Widget? child;

  const CustomTitle({Key? key, this.child}) : super(key: key);

  @override
  _CustomTitleState createState() => _CustomTitleState(); // Create State
}

class _CustomTitleState extends State<CustomTitle> with SingleTickerProviderStateMixin { // Add TickerProvider
  late AnimationController _animationController; // AnimationController
  late Animation<double> _animation; // Animation

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController( // Initialize AnimationController
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Animation duration
    )..repeat(reverse: true); // Repeat animation in reverse

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate( // Define animation tween
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Animation curve
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final beerFontSize = screenHeight * 0.11;
    final wrappedFontSize = screenHeight * 0.08;

    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder( // AnimatedBuilder for animation
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: degreesToRadians(-16),
                  child: Transform.scale( // Transform.scale for size animation
                    scale: _animation.value, // Use animated scale value
                    child: Text(
                      'BEER',
                      style: TextStyle(
                        fontFamily: 'Kameron',
                        fontWeight: FontWeight.bold,
                        fontSize: beerFontSize,
                        color: const Color(0xFFFAF3E0),
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(7.0, 7.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(-2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(2.0, -2.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(-2.0, -2.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder( // AnimatedBuilder for animation
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: degreesToRadians(5),
                  child: Transform.scale( // Transform.scale for size animation
                    scale: _animation.value, // Use animated scale value
                    child: Text(
                      'WRAPPED',
                      style: TextStyle(
                        fontFamily: 'Kameron',
                        fontWeight: FontWeight.bold,
                        fontSize: wrappedFontSize,
                        color: const Color(0xFFFAF3E0),
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(7.0, 7.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(-2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(2.0, -2.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(-2.0, -2.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            if (widget.child != null) widget.child!, // Use widget.child
          ],
        ),
      ),
    );
  }

  double degreesToRadians(double x) {
    return x * math.pi / 180;
  }
}