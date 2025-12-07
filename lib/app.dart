import 'package:beerwrapped/providers/user_provider.dart';
import 'package:beerwrapped/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/chooseDay_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<UserProvider>().loadSession();
    return MaterialApp(
      title: 'Beer Wrapped',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/chooseDay': (context) => const ChooseDayScreen(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations
            .delegate, // Es buena práctica incluirlo si usas iOS
      ],
      supportedLocales: const [
        Locale('ca', ''), // Català
        //Locale('en', ''), // Anglès
      ],
    );
  }
}
