// components/groups/group_card.dart
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final Map<String, dynamic> group;
  final bool isOwner;
  final VoidCallback onTap;

  const GroupCard({
    Key? key,
    required this.group,
    required this.isOwner,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEDE4D3),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.group,
          color: Color(0xFFB5884C),
          size: 32,
        ),
        title: Row(
          children: [
            Text(
              group['name'],
              style: const TextStyle(
                fontFamily: 'Kameron',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (isOwner) ...[
              const SizedBox(width: 6),
              const Icon(Icons.star, size: 14, color: Color(0xFFB5884C)),
            ],
          ],
        ),
        subtitle:
            group['description'] != null && group['description'].isNotEmpty
                ? Text(group['description'])
                : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
