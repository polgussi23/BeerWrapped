// components/groups/group_meetups_tab.dart
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/groups_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupMeetupsTab extends StatefulWidget {
  final int groupId;

  const GroupMeetupsTab({Key? key, required this.groupId}) : super(key: key);

  @override
  _GroupMeetupsTabState createState() => _GroupMeetupsTabState();
}

class _GroupMeetupsTabState extends State<GroupMeetupsTab> {
  late Future<List<Map<String, dynamic>>> _meetupsFuture;

  @override
  void initState() {
    super.initState();
    _loadMeetups();
  }

  void _loadMeetups() {
    DateTime now = DateTime.now();
    String date = "${now.year}-${now.month}-${now.day}";
    _meetupsFuture =
        GroupsService().getGroupMeetups(widget.groupId.toString(), date);
  }

  Future<void> _attendMeetup(int meetupId) async {
    try {
      final userId = context.read<UserProvider>().getUserId();
      await GroupsService().attendToMeetup(
        userId.toString(),
        widget.groupId.toString(),
        meetupId.toString(),
      );
      setState(() => _loadMeetups());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.toString().contains('409')
                ? 'Ja estàs apuntat a aquesta quedada'
                : 'Error al apuntar-se')),
      );
    }
  }

  String _formatDate(String dateStr) {
    final parts = dateStr.substring(0, 10).split('-');
    final day = int.parse(parts[2]);
    final month = int.parse(parts[1]);
    final year = parts[0];
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

  Future<void> _showAttendees(BuildContext context, int meetupId) async {
    // Mostrem un loading primer
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final attendees = await GroupsService().getMeetupAttendees(
        widget.groupId.toString(),
        meetupId.toString(),
      );

      if (!mounted) return;
      Navigator.pop(context); // tanquem el loading

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFFEDE4D3),
          title: const Text(
            'Apuntats',
            style: TextStyle(
              fontFamily: 'Kameron',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: attendees.isEmpty
              ? const Text('Ningú s\'ha apuntat encara')
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: attendees.length,
                    itemBuilder: (context, index) {
                      final attendee = attendees[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFFB5884C),
                          backgroundImage: attendee['profileImage'] != null
                              ? NetworkImage(attendee['profileImage'])
                              : null,
                          child: attendee['profileImage'] == null
                              ? Text(
                                  (attendee['username'] as String)
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
                          attendee['username'],
                          style: const TextStyle(fontFamily: 'Kameron'),
                        ),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tancar'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al carregar els assistents')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _meetupsFuture,
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
                  'Error carregant les quedades\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() => _loadMeetups()),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final meetups = snapshot.data!;

        if (meetups.isEmpty) {
          return const Center(
            child: Text(
              'No hi ha quedades planificades.\nCrea\'n una!',
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: meetups.length,
          itemBuilder: (context, index) {
            final meetup = meetups[index];
            return Card(
              color: const Color(0xFFEDE4D3),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event, color: Color(0xFFB5884C)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatDate(meetup['date']),
                            style: const TextStyle(
                              fontFamily: 'Kameron',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          meetup['time'].substring(0, 5), // HH:mm
                          style: const TextStyle(
                            fontFamily: 'Kameron',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB5884C),
                          ),
                        ),
                      ],
                    ),
                    if (meetup['location'] != null &&
                        meetup['location'].isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.black54),
                          const SizedBox(width: 4),
                          Text(
                            meetup['location'],
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person,
                            size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          'Organitza: ${meetup['creator']}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => _showAttendees(context, meetup['id']),
                          child: Row(
                            children: [
                              const Icon(Icons.group,
                                  size: 16, color: Color(0xFFB5884C)),
                              const SizedBox(width: 4),
                              Text(
                                '${meetup['attendeesCount']} apuntats',
                                style: const TextStyle(
                                  color: Color(0xFFB5884C),
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _attendMeetup(meetup['id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB5884C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'm\'apunto!',
                          style: TextStyle(
                            fontFamily: 'Kameron',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
