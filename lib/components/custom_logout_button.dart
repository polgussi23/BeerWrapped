import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/logout_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({Key? key, required this.onPressed}) : super(key: key);

  void closeSession(BuildContext context) async {
    final logoutService = LogoutService();
    try {
      await logoutService
          .logoutUser(context.read<UserProvider>().getRefreshToken());
    } catch (e) {
      print('Error logging out: $e');
    }

    context.read<UserProvider>().logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
      icon: const Icon(Icons.logout),
      label: const Text('Tanca la sessió'),
      onPressed: () => closeSession(context),
    );
  }
}
