import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tubes_pm/authentication/authGate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Firebase
  await Firebase.initializeApp();

  // Request permission (Android 13+ & iOS)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Optional: cek token (buat debug)
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM TOKEN: $token');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
