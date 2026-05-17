import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/screens/chooseAction_screen.dart';
import 'package:birrawrapped/screens/chooseDrink_screen.dart';
import 'package:birrawrapped/screens/groups/create_group_screen.dart';
import 'package:birrawrapped/screens/groups/create_meetup_screen.dart';
import 'package:birrawrapped/screens/groups/group_detail_screen.dart';
import 'package:birrawrapped/screens/groups/join_group_screen.dart';
import 'package:birrawrapped/screens/main_screen.dart';
import 'package:birrawrapped/screens/profile/edit_email_screen.dart';
import 'package:birrawrapped/screens/profile/edit_password_screen.dart';
import 'package:birrawrapped/screens/profile/edit_username_screen.dart';
import 'package:birrawrapped/screens/splash_screen.dart';
import 'package:birrawrapped/screens/waitToStart_screen.dart';
import 'package:birrawrapped/screens/wrapped/wrapped_screen.dart';
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
      title: 'Birra Wrapped',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/chooseDay': (context) => const ChooseDayScreen(),
        '/waittostart': (context) => const WaittostartScreen(),
        '/chooseAction': (context) => const ChooseActionScreen(),
        '/chooseDrink': (context) => const ChooseDrinkScreen(),
        '/home': (context) => const MainScreen(),
        '/createGroup': (context) => const CreateGroupScreen(),
        '/joinGroup': (context) => const JoinGroupScreen(),
        '/groupDetail': (context) => const GroupDetailScreen(),
        '/createMeetup': (context) => const CreateMeetupScreen(),
        '/editUsername': (context) => const EditUsernameScreen(),
        '/editEmail': (context) => const EditEmailScreen(),
        '/editPassword': (context) => const EditPasswordScreen(),
        '/wrapped': (context) => const WrappedScreen(),
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
