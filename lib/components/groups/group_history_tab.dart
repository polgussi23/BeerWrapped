// components/groups/group_history_tab.dart
import 'package:birrawrapped/models/group_user_info.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/groups_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupHistoryTab extends StatefulWidget {
  final int groupId;
  final String privacy;

  const GroupHistoryTab(
      {Key? key, required this.groupId, required this.privacy})
      : super(key: key);

  @override
  _GroupHistoryTabState createState() => _GroupHistoryTabState();
}

class _GroupHistoryTabState extends State<GroupHistoryTab> {
  late Future<List<Map<String, dynamic>>> _historyFuture;
  //late Future<GroupUserInfo?> _userInfo;

  @override
  void initState() {
    super.initState();
    //_historyFuture = Future.value(<Map<String, dynamic>>[]);
    //_getUserInfo();
    if (widget.privacy == "public") {
      _historyFuture = _fetchHistory();
    } else {
      _historyFuture = Future.value(<Map<String, dynamic>>[]);
    }
  }

  @override
  void didUpdateWidget(covariant GroupHistoryTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.privacy != widget.privacy) {
      setState(() {
        if (widget.privacy == "public") {
          _historyFuture = _fetchHistory();
        } else {
          _historyFuture = Future.value(<Map<String, dynamic>>[]);
        }
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final date = DateTime.now().subtract(const Duration(days: 2));
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return GroupsService()
        .getGroupBeersHistory(widget.groupId.toString(), dateStr);
  }

  Widget _buildPrivacyWarningCard() {
    return Card(
      color: const Color(0xFFEDE4D3),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFB5884C), width: 1),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_outline, color: Color(0xFFB5884C)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'EP! Tens la privacitat activada. L\'historial d\'activitat no és visible.',
                style: TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
    final isPrivate = widget.privacy == "private";

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              if (isPrivate) _buildPrivacyWarningCard(),
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }

        if (snapshot.hasError) {
          return Column(
            children: [
              if (isPrivate) _buildPrivacyWarningCard(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
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
                ),
              ),
            ],
          );
        }

        final entries = snapshot.data!;

        if (entries.isEmpty) {
          return Column(
            children: [
              if (isPrivate) _buildPrivacyWarningCard(),
              const Expanded(
                child: Center(
                  child: Text(
                    'Sense activitat els últims 3 dies',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        }

        final grouped = _groupByDate(entries);
        final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: dates.length + (isPrivate ? 1 : 0),
          itemBuilder: (context, index) {
            if (isPrivate && index == 0) {
              return _buildPrivacyWarningCard();
            }
            final adjustedIndex = isPrivate ? index - 1 : index;
            final date = dates[adjustedIndex];
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
