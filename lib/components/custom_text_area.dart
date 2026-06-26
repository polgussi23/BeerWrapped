import 'package:flutter/material.dart';

class CustomTextArea extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Icon? icon;
  final int minLines;
  final int? maxLines; // null = sense límit, creix indefinidament

  const CustomTextArea({
    Key? key,
    required this.hintText,
    required this.controller,
    this.icon,
    this.minLines = 3,
    this.maxLines,
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
              color: Colors.black.withOpacity(0.7),
              offset: const Offset(3, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          minLines: minLines, // alçada inicial (en "línies")
          maxLines: maxLines, // null -> creix sense límit
          style: TextStyle(
              color: const Color(0xC2FAF3E0),
              fontFamily: 'Kameron',
              fontSize: screenHeight * 0.022),
          cursorColor: const Color(0XFFFAF3E0),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
                color: Color(0x7AFAF3E0), fontFamily: 'Kameron'),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
            alignLabelWithHint:
                true, // perquè el prefixIcon no quedi enganxat a dalt si hi ha icona
          ),
        ),
      ),
    );
  }
}
