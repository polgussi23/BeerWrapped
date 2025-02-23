import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFFAF3E0)),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0), // Ajusta el padding si cal
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Corner radius 15
          ),
        ),
      ),
      child: Transform.rotate( // Rotar el text
        angle: degreesToRadians(3), // Rotació de -3 graus
        child: DefaultTextStyle(
          style: const TextStyle(
            fontFamily: 'Kameron',
            color: Color(0xFF1E3636), // Color de la lletra 1E3636
            fontWeight: FontWeight.bold,
            fontSize: 18, // Ajusta la mida de la lletra si cal
          ),
          child: child, // Widget child per al text del botó
        ),
      ),
    );
  }

  double degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}