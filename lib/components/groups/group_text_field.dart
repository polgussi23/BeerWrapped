// components/groups/group_text_field.dart
import 'package:flutter/material.dart';

class GroupTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final TextStyle? style;

  const GroupTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textAlign: textAlign,
      textCapitalization: textCapitalization,
      style: style,
      cursorColor: const Color(0xFFB5884C),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: const Color(0xFFEDE4D3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB5884C), width: 2),
        ),
      ),
    );
  }
}
