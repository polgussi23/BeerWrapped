import 'package:flutter/material.dart';

class CustomSmallTitle extends StatelessWidget {
  final String text;

  const CustomSmallTitle({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 35.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Kameron',
          fontSize: screenWidth * 0.08,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: Colors.white,
          shadows: const [
            Shadow(
              blurRadius: 6,
              color: Colors.black26,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
