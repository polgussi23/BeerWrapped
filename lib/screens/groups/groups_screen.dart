// screens/groups/groups_screen.dart
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/components/groups/group_action_buttons.dart';
import 'package:birrawrapped/components/groups/group_card.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/groups_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  late Future<List<Map<String, dynamic>>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    _groupsFuture = _fetchGroups();
  }

  Future<List<Map<String, dynamic>>> _fetchGroups() async {
    final userId = context.read<UserProvider>().getUserId();
    return GroupsService().getAllUserGroups(userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserProvider>().getUserId();

    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSmallTitle(text: "Els meus grups"),
                  const SizedBox(height: 8),
                  GroupActionButtons(
                    onCreateTap: () async {
                      await Navigator.pushNamed(context, '/createGroup');
                      setState(() => _loadGroups());
                    },
                    onJoinTap: () async {
                      await Navigator.pushNamed(context, '/joinGroup');
                      setState(() => _loadGroups());
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _groupsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 48, color: Colors.red),
                                const SizedBox(height: 8),
                                Text(
                                  'Error carregant els grups\n${snapshot.error}',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      setState(() => _loadGroups()),
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          );
                        }

                        final groups = snapshot.data!;

                        if (groups.isEmpty) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE4D3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Encara no formes part de cap grup.\nCrea\'n un o uneix-te a un existent!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Kameron',
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            final group = groups[index];
                            final isOwner = group['ownerId'] == userId;

                            return GroupCard(
                              group: group,
                              isOwner: isOwner,
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/groupDetail',
                                arguments: group,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
