// components/beer_entry_card.dart
import 'package:flutter/material.dart';

class BeerEntryCard extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onDelete;

  const BeerEntryCard({
    Key? key,
    required this.entry,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEDE4D3),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.sports_bar,
          color: Color(0xFFB5884C),
        ),
        title: Text(
          (entry['name'] as String).substring(0, 1).toUpperCase() +
              (entry['name'] as String).substring(1),
          style: const TextStyle(
            fontFamily: 'Kameron',
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(entry['time']),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
