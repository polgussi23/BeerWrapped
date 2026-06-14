import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_title.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:birrawrapped/services/sync_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:birrawrapped/services/version_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version;

      final versionInfo = await VersionService().checkVersion();
      final latestVersion = versionInfo['latestVersion']!;
      final minVersion = versionInfo['minVersion']!;

      final isBelowMin = _isOlderThan(currentVersion, minVersion);
      final isBelowLatest = _isOlderThan(currentVersion, latestVersion);

      if (isBelowMin) {
        await _showUpdateDialog(forced: true);
        return;
      } else if (isBelowLatest) {
        await _showUpdateDialog(forced: false);
      }
    } catch (_) {}

    _checkSession();
  }

  bool _isOlderThan(String current, String reference) {
    final c = current.split('.').map(int.parse).toList();
    final r = reference.split('.').map(int.parse).toList();
    for (int i = 0; i < 3; i++) {
      if (c[i] < r[i]) return true;
      if (c[i] > r[i]) return false;
    }
    return false;
  }

  Future<void> _showUpdateDialog({required bool forced}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFEDE4D3),
        title: Text(
          forced ? 'Actualització necessària 🍺' : 'Nova versió disponible 🍺',
          style: const TextStyle(
            fontFamily: 'Kameron',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          forced
              ? 'Cal actualitzar l\'app per poder continuar utilitzant BirraWrapped.'
              : 'Hi ha una nova versió de BirraWrapped disponible. Vols actualitzar ara?',
          style: const TextStyle(fontFamily: 'Kameron'),
        ),
        actions: [
          if (!forced)
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
                  const Text('Ara no', style: TextStyle(color: Colors.black54)),
            ),
          TextButton(
            onPressed: () async {
              final url = Uri.parse(
                'https://play.google.com/store/apps/details?id=cat.polgussi.birrawrapped',
              );
              if (await canLaunchUrl(url)) launchUrl(url);
            },
            child: const Text(
              'Actualitzar 🍻',
              style: TextStyle(
                color: Color(0xFFB5884C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkSession() async {
    if (!mounted) return;

    final up = context.read<UserProvider>();

    if (!up.isLogged()) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    if (!up.isEmailVerified()!) {
      Navigator.pushReplacementNamed(context, '/validateEmail');
      return;
    }

    final DateTime? startDay = up.getStartDay();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    if (startDay == null) {
      Navigator.pushReplacementNamed(context, '/chooseDay');
      return;
    }

    if (startDay.difference(today).inDays > 0) {
      Navigator.pushReplacementNamed(context, '/waittostart');
      return;
    }

    final DateTime wrappedDate =
        DateTime(startDay.year + 1, startDay.month, startDay.day);

    if (today.isAtSameMomentAs(wrappedDate) || today.isAfter(wrappedDate)) {
      Navigator.pushReplacementNamed(context, '/chooseDay');
      return;
    }

    SyncService().syncPending();
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          CustomBackground(), // mateix fons que la resta de l'app
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTitle(), // el logo "BIRRA WRAPPED" que ja tens
                SizedBox(height: 48),
                CircularProgressIndicator(
                  color: Color(0xFFB5884C), // color daurat de l'app
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
