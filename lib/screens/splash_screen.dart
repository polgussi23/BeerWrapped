import 'package:beerwrapped/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // opcional: retard per mostrar el logo/animació
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (!context.read<UserProvider>().isLogged()) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      UserProvider up = context.read<UserProvider>();
      print(
          "Connectat automàticament: userId: ${up.getUserId()}, username: ${up.getUsername()}, refreshToken: ${up.getRefreshToken()}");
      Navigator.pushReplacementNamed(context, '/chooseDay');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // aquí podries posar un logo també
      ),
    );
  }
}
