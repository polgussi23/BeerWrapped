// screens/profile/profile_screen.dart
import 'dart:io';
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/components/custom_logout_button.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _userFuture;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    _userFuture = _fetchUser();
  }

  Future<Map<String, dynamic>> _fetchUser() async {
    final userId = context.read<UserProvider>().getUserId();
    return UserService().getUserData(userId.toString());
  }

  Future<void> _pickAndUploadPhoto(String userId) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (picked == null) return;

    try {
      await UserService().updateProfileImage(userId, File(picked.path));
      setState(() => _loadUser());
    } catch (e) {
      print('ERROR FOTO: $e'); // <-- afegeix això
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualitzar la foto de perfil')),
      );
    }
  }

  String _getInitials(String username) {
    return username.substring(0, 1).toUpperCase();
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

  int _getDaysLeft(String startDay) {
    final parts = startDay.split('-');
    final start = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final finalDate = DateTime(start.year + 1, start.month, start.day);
    final today = DateTime.now();
    final todayClean = DateTime(today.year, today.month, today.day);
    return finalDate.difference(todayClean).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserProvider>().getUserId().toString();

    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                          'Error carregant el perfil\n${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() => _loadUser()),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final user = snapshot.data!;
                final daysLeft = user['startDay'] != null
                    ? _getDaysLeft(user['startDay'])
                    : null;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomSmallTitle(text: 'Perfil'),
                      const SizedBox(height: 16),

                      // Foto de perfil
                      GestureDetector(
                        onTap: () => _pickAndUploadPhoto(userId),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: const Color(0xFFB5884C),
                              backgroundImage: user['profileImage'] != null
                                  ? NetworkImage(user['profileImage'])
                                  : null,
                              child: user['profileImage'] == null
                                  ? Text(
                                      _getInitials(user['username']),
                                      style: const TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontFamily: 'Kameron',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFB5884C),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Username
                      Text(
                        user['username'],
                        style: const TextStyle(
                          fontFamily: 'Kameron',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        user['email'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Estadístiques
                      if (user['startDay'] != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.calendar_today,
                                label: 'Inici',
                                value: _formatDate(user['startDay']),
                                small: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.hourglass_bottom,
                                label: 'Dies restants',
                                value: daysLeft != null
                                    ? daysLeft > 0
                                        ? '$daysLeft dies'
                                        : 'Acaba avui!'
                                    : '-',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Opcions d'edició
                      _SectionTitle(text: 'Editar perfil'),
                      const SizedBox(height: 8),
                      _EditOption(
                        icon: Icons.person_outline,
                        label: 'Canviar username',
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/editUsername',
                            arguments: user['username'],
                          );
                          setState(() => _loadUser());
                        },
                      ),
                      _EditOption(
                        icon: Icons.email_outlined,
                        label: 'Canviar email',
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/editEmail',
                            arguments: user['email'],
                          );
                          setState(() => _loadUser());
                        },
                      ),
                      _EditOption(
                        icon: Icons.lock_outline,
                        label: 'Canviar contrasenya',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/editPassword',
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Logout
                      LogoutButton(onPressed: () {
                        print('Tanca la sessió');
                      }),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget per a les targetes d'estadístiques
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool small;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE4D3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFB5884C), size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
              fontFamily: 'Kameron',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Kameron',
              fontSize: small ? 13 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget per al títol de secció
class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Kameron',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    );
  }
}

// Widget per a cada opció d'edició
class _EditOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _EditOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEDE4D3),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFB5884C)),
        title: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Kameron',
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black45),
        onTap: onTap,
      ),
    );
  }
}
