import 'package:birrawrapped/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final up = context.read<UserProvider>();

    if (!up.isLogged()) {
      Navigator.pushReplacementNamed(context, '/login');
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

    print(today);
    print(wrappedDate);
    if (today.isAtSameMomentAs(wrappedDate) || today.isAfter(wrappedDate)) {
      /*
      final prefs = await SharedPreferences.getInstance();
      final wrappedSeenDate = prefs.getString('wrappedSeenDate');

      
      if (wrappedSeenDate == null) {
        // Primera vegada — anem al wrapped
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }


      final seenDate = DateTime.parse(wrappedSeenDate);
      final daysSinceSeen = today.difference(seenDate).inDays;

      if (daysSinceSeen <= 7) {
        // Dins la setmana — anem a home (el botó apareixerà allà)
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }

      // Més de 7 dies — netegem i anem a chooseDay
      await prefs.remove('wrappedSeenDate');
      */
      Navigator.pushReplacementNamed(context, '/chooseDay');
      return;
    }

    Navigator.pushReplacementNamed(context, '/home');
  }

  /*
  Future<bool?> _showReviewWrappedDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFEDE4D3),
        title: const Text(
          'El teu BirraWrapped 🍺',
          style: TextStyle(
            fontFamily: 'Kameron',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Vols tornar a veure el resum del teu any en birres?',
          style: TextStyle(fontFamily: 'Kameron'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Ara no',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Sí, vull veure\'l! 🍻',
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
  */

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
