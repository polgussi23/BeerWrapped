import 'package:birrawrapped/app.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:birrawrapped/services/sync_service.dart';

void main() async {
  await dotenv.load();
  await Firebase.initializeApp();
  SyncService().startListening();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}
