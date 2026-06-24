// screens/groups/group_detail_screen.dart
import 'package:birrawrapped/components/groups/group_QR_dialog.dart';
import 'package:birrawrapped/components/groups/group_history_tab.dart';
import 'package:birrawrapped/components/groups/group_meetups_tab.dart';
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/loading_screen.dart';
import 'package:birrawrapped/models/group_user_info.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/groups_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:share_plus/share_plus.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({Key? key}) : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  GroupUserInfo? _groupUserInfo;
  bool _isLoadingUserInfo = true;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _groupUserInfo =
        GroupUserInfo(role: '', privacy: '', canChangeToPrivate: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final group =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _getUserInfo(group['id'].toString());
    }
  }

  /*void _showGroupQR(BuildContext context, String code) {
    final baseUrl = dotenv.env['API_URL'] ?? 'http://217.160.2.122:3100';
    //final baseUrl = 'http://birrawrapped.polgussi.cat:3100';
    final inviteUrl = '$baseUrl/join?code=$code';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFEDE4D3),
        title: const Text(
          'Convida al grup',
          style: TextStyle(fontFamily: 'Kameron', fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 260,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Escaneja el QR o comparteix el codi:',
                style: TextStyle(fontFamily: 'Kameron'),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: inviteUrl, // <-- la URL completa, no només el codi
                  version: QrVersions.auto,
                  size: 180,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB5884C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      code,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Kameron',
                        fontSize: 14, // <-- abans 22
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 3, // <-- abans 5
                      ),
                    ),
                    const Text(
                      'codi d\'accés manual',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                        fontFamily: 'Kameron',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Share.share(
                      'Uneix-te al meu grup del BirraWrapped! 🍺\n$inviteUrl\n\nCodi: $code',
                    );
                  },
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: const Text(
                    'Compartir',
                    style:
                        TextStyle(fontFamily: 'Kameron', color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366), // verd WhatsApp
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
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
  }*/

  Future<void> _showMembers(
      BuildContext context, Map<String, dynamic> group) async {
    final userId = context.read<UserProvider>().getUserId();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final members =
          await GroupsService().getMembersOfGroup(group['id'].toString());
      if (!mounted) return;
      Navigator.pop(context);

      // Trobem el rol de l'usuari actual
      final currentUserMember = members.firstWhere(
        (m) => m['id'] == userId,
        orElse: () => {'role': 'user'},
      );
      final currentUserRole = currentUserMember['role'];
      final canManage = ['admin', 'owner'].contains(currentUserRole);
      // També el tipus de privacitat

      showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            backgroundColor: const Color(0xFFEDE4D3),
            title: const Text(
              'Membres',
              style: TextStyle(
                fontFamily: 'Kameron',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final isOwner = member['role'] == 'owner';
                  final isAdmin = member['role'] == 'admin';
                  final isCurrentUser = member['id'] == userId;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFB5884C),
                      backgroundImage: member['profileImage'] != null
                          ? NetworkImage(member['profileImage'])
                          : null,
                      child: member['profileImage'] == null
                          ? Text(
                              (member['username'] as String)
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
                      member['username'],
                      style: const TextStyle(fontFamily: 'Kameron'),
                    ),
                    subtitle: Text(
                      isOwner
                          ? '👑 Owner'
                          : isAdmin
                              ? '⭐ Admin'
                              : 'Membre',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOwner
                            ? const Color(0xFFB5884C)
                            : isAdmin
                                ? Colors.blueGrey
                                : Colors.black45,
                      ),
                    ),
                    // Opcions per a admins/owners
                    trailing: canManage && !isOwner && !isCurrentUser
                        ? PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.black45),
                            onSelected: (value) async {
                              Navigator.pop(ctx);
                              if (value == 'remove') {
                                await _removeMember(
                                    context, group, member, members);
                              } else if (value == 'toggleAdmin') {
                                await _toggleAdmin(
                                    context, group, member, isAdmin);
                              }
                            },
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                value: 'toggleAdmin',
                                child: Text(
                                  isAdmin ? 'Treure admin' : 'Fer admin',
                                  style: const TextStyle(fontFamily: 'Kameron'),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'remove',
                                child: Text(
                                  'Eliminar del grup',
                                  style: TextStyle(
                                    fontFamily: 'Kameron',
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : null,
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
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al carregar els membres')),
      );
    }
  }

  Future<void> _removeMember(BuildContext context, Map<String, dynamic> group,
      Map<String, dynamic> member, List<Map<String, dynamic>> members) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFEDE4D3),
        title: const Text('Eliminar membre'),
        content: Text(
            'Estàs segur que vols eliminar ${member['username']} del grup?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel·lar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await GroupsService().removeMember(
          group['id'],
          member['id'],
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${member['username']} eliminat del grup')),
        );
        // Tornem a mostrar els membres actualitzats
        _showMembers(context, group);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el membre')),
        );
      }
    }
  }

  Future<void> _toggleAdmin(BuildContext context, Map<String, dynamic> group,
      Map<String, dynamic> member, bool isAdmin) async {
    try {
      final newRole = isAdmin ? 'user' : 'admin';
      await GroupsService().updateMemberRole(
        group['id'].toString(),
        member['id'].toString(),
        newRole,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAdmin
              ? '${member['username']} ja no és admin'
              : '${member['username']} ara és admin'),
        ),
      );
      _showMembers(context, group);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al canviar el rol')),
      );
    }
  }

  Future<void> _getUserInfo(String groupId) async {
    final userId = context.read<UserProvider>().getUserId();
    GroupUserInfo? g = await GroupsService()
        .getGroupUserInfo(groupId.toString(), userId.toString());

    if (!mounted) return;

    setState(() {
      _groupUserInfo = g;
      _isLoadingUserInfo = false;
    });
  }

  Future<void> _changeGroupUserPrivacy(String groupId, String privacy) async {
    final newPrivacy = privacy == "public" ? "private" : "public";

    //Color(0xFFEDE4D3)
    // 1. Comprovació local abans de res (evita una petició innecessària)
    if (newPrivacy == "private" && !_groupUserInfo!.canChangeToPrivate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No pots tornar a privat fins que no passin 24h des de l'últim canvi a públic.",
          ),
        ),
      );
      return;
    }

    // 2. Diàleg de confirmació
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFEDE4D3),
        title: const Text('Canviar privacitat'),
        content: Text(
          newPrivacy == 'public'
              ? "Vols fer públic el teu historial dins d'aquest grup?"
              : "Vols fer privat el teu historial dins d'aquest grup?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel·lar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Confirmar', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    // 3. Petició al backend
    try {
      final userId = context.read<UserProvider>().getUserId();
      await GroupsService()
          .updateGroupUserPrivacy(groupId, userId.toString(), newPrivacy);

      if (!mounted) return;

      // 4. Refresquem la info de l'usuari per mantenir-la sincronitzada amb el backend
      await _getUserInfo(groupId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final group =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (_isLoadingUserInfo) {
      return LoadingScreen(
        text: "Carregant grup...",
        title: group['name'],
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            const CustomBackground(),
            SafeArea(
              child: Column(
                children: [
                  // Capçalera
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group['name'],
                                style: const TextStyle(
                                  fontFamily: 'Kameron',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    GroupQrDialog.show(context, group['code']),
                                child: const Row(
                                  children: [
                                    Icon(Icons.qr_code,
                                        size: 12, color: Color(0xFFB5884C)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Convida algú',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFB5884C),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () => _changeGroupUserPrivacy(
                                group['id'].toString(),
                                _groupUserInfo!.privacy),
                            icon: Icon(
                                _groupUserInfo!.privacy == "public"
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                                size: 26)),
                        // Botó de membres
                        IconButton(
                          icon: const Icon(Icons.group,
                              color: Colors.white70, size: 26),
                          onPressed: () => _showMembers(context, group),
                          tooltip: 'Membres',
                        ),
                        // Botó de crear quedada
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: Color(0xFFB5884C), size: 28),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/createMeetup',
                            arguments: group,
                          ),
                          tooltip: 'Crear quedada',
                        ),
                      ],
                    ),
                  ),
                  // Pestanyes
                  Container(
                    color: Colors.white12,
                    child: const TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white54,
                      indicatorColor: Color(0xFFB5884C),
                      labelStyle: TextStyle(
                        fontFamily: 'Kameron',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      tabs: [
                        Tab(text: 'Historial'),
                        Tab(text: 'Quedades'),
                      ],
                    ),
                  ),
                  // Contingut de les pestanyes
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TabBarView(
                        children: [
                          GroupHistoryTab(
                              groupId: group['id'],
                              privacy: _groupUserInfo!.privacy),
                          GroupMeetupsTab(groupId: group['id']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
