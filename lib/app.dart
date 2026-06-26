import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/screens/chooseAction_screen.dart';
import 'package:birrawrapped/screens/chooseDrink_screen.dart';
import 'package:birrawrapped/screens/forgot_password_screen.dart';
import 'package:birrawrapped/screens/groups/create_group_screen.dart';
import 'package:birrawrapped/screens/groups/create_meetup_screen.dart';
import 'package:birrawrapped/screens/groups/group_detail_screen.dart';
import 'package:birrawrapped/screens/groups/join_group_screen.dart';
import 'package:birrawrapped/screens/main_screen.dart';
import 'package:birrawrapped/screens/profile/edit_email_screen.dart';
import 'package:birrawrapped/screens/profile/edit_password_screen.dart';
import 'package:birrawrapped/screens/profile/edit_username_screen.dart';
import 'package:birrawrapped/screens/sendIdea_screen.dart';
import 'package:birrawrapped/screens/splash_screen.dart';
import 'package:birrawrapped/screens/verify_email_screen.dart';
import 'package:birrawrapped/screens/waitToStart_screen.dart';
import 'package:birrawrapped/screens/wrapped/wrapped_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/chooseDay_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_links/app_links.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // App oberta des de zero pel link
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) _handleLink(initialLink);

    // App ja oberta en segon pla
    _appLinks.uriLinkStream.listen((uri) => _handleLink(uri));
  }

  void _handleLink(Uri uri) {
    if (uri.path == '/join') {
      final code = uri.queryParameters['code'];
      if (code == null) return;

      final userProvider = _navigatorKey.currentContext?.read<UserProvider>();
      final isLoggedIn = userProvider?.getUserId() != null;

      if (isLoggedIn) {
        _navigatorKey.currentState?.pushNamed('/joinGroup', arguments: code);
      } else {
        // Guardem el codi i el processem després del login
        userProvider?.setPendingGroupCode(code);
        _navigatorKey.currentState?.pushNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserProvider>().loadSession();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      title: 'Birra Wrapped',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/validateEmail': (context) => const VerifyEmailScreen(),
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
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/wrapped': (context) => const WrappedScreen(),
        '/sendIdea': (context) => const sendIdeaScreen(),
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
