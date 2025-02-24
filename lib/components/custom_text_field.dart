import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Icon icon;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7), // Color de l'ombra
              offset: const Offset(3, 3), // Posició: dreta i avall
              blurRadius: 5, // Difuminació de l'ombra
            ),
          ],
        ),
        child: SizedBox(
          height: screenHeight*0.025 * 2,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(color: Color(0xC2FAF3E0), fontFamily: 'Kameron', fontSize: screenHeight*0.025),
            cursorColor: const Color(0XFFFAF3E0),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0x7AFAF3E0), fontFamily: 'Kameron'),
              contentPadding: const EdgeInsets.symmetric(vertical: -2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xE62C2C2C)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xE62C2C2C)),
              ),
              filled: true,
              fillColor: const Color(0xE62C2C2C),
              prefixIcon: icon,
            ),
          ),
        ),
      ),
    );
  }
}
