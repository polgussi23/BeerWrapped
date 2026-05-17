// components/groups/group_history_tab.dart
import 'package:birrawrapped/services/groups_service.dart';
import 'package:flutter/material.dart';

class GroupHistoryTab extends StatefulWidget {
  final int groupId;

  const GroupHistoryTab({Key? key, required this.groupId}) : super(key: key);

  @override
  _GroupHistoryTabState createState() => _GroupHistoryTabState();
}

class _GroupHistoryTabState extends State<GroupHistoryTab> {
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
  }

  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final date = DateTime.now().subtract(const Duration(days: 2));
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return GroupsService()
        .getGroupBeersHistory(widget.groupId.toString(), dateStr);
  }

  Map<String, List<Map<String, dynamic>>> _groupByDate(
      List<Map<String, dynamic>> entries) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final entry in entries) {
      grouped.putIfAbsent(entry['date'], () => []).add(entry);
    }
    for (final key in grouped.keys) {
      grouped[key]!
          .sort((a, b) => (b['time'] as String).compareTo(a['time'] as String));
    }
    return grouped;
  }

  String _formatDate(String dateStr) {
    final parts = dateStr.substring(0, 10).split('-');
    final year = parts[0];
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    final months = [
      '',
      'gener',
      'febrer',
      'març',
      'abril',
      'maig',
      'juny',
      'juliol',
      'agost',
      'setembre',
      'octubre',
      'novembre',
      'desembre'
    ];
    return '$day de ${months[month]} del $year';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 8),
                Text(
                  'Error carregant l\'historial\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _historyFuture = _fetchHistory();
                  }),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final entries = snapshot.data!;

        if (entries.isEmpty) {
          return const Center(
            child: Text(
              'Sense activitat els últims 3 dies',
              textAlign: TextAlign.center,
            ),
          );
        }

        final grouped = _groupByDate(entries);
        final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final date = dates[index];
            final dayEntries = grouped[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB5884C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${dayEntries.first['dayOfWeek']} · ${_formatDate(date)}',
                      style: const TextStyle(
                        fontFamily: 'Kameron',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ...dayEntries.map((entry) => Card(
                      color: const Color(0xFFEDE4D3),
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFB5884C),
                          backgroundImage: entry['profileImage'] != null
                              ? NetworkImage(entry['profileImage'])
                              : null,
                          child: entry['profileImage'] == null
                              ? Text(
                                  (entry['username'] as String)
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Kameron',
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        title: Text(
                          (entry['name'] as String)
                                  .substring(0, 1)
                                  .toUpperCase() +
                              (entry['name'] as String).substring(1),
                          style: const TextStyle(
                            fontFamily: 'Kameron',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(entry['username']),
                        trailing: Text(
                          entry['time'],
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    )),
              ],
            );
          },
        );
      },
    );
  }
}
