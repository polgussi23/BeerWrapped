// components/groups/group_cancel_button.dart
import 'package:flutter/material.dart';

class GroupCancelButton extends StatelessWidget {
  const GroupCancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(100, 250, 243, 224),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      ),
      child: const Text(
        'Cancel·lar',
        style: TextStyle(
          fontFamily: 'Kameron',
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }
}
