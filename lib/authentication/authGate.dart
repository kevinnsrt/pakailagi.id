  import 'dart:convert';

  import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:flutter/material.dart';
  import 'package:tubes_pm/authentication/token.dart';
  import 'package:tubes_pm/dashboard/bottom-navbar.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:tubes_pm/screen/splash.dart';
  import 'package:http/http.dart' as http;
  class AuthGate extends StatefulWidget {
    const AuthGate({super.key});

    @override
    State<AuthGate> createState() => _AuthGateState();
  }

  class _AuthGateState extends State<AuthGate> {
    bool _tokenSent = false;

    Future<void> sendFcmToken() async {
      final user = FirebaseAuth.instance.currentUser;
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final firebaseIdToken = await user!.getIdToken();

      if (fcmToken == null || firebaseIdToken == null) return;

      final response = await http.post(
        Uri.parse('https://pakailagi.user.cloudjkt02.com/api/save-fcm-token'),
        headers: {
          'Authorization': 'Bearer $firebaseIdToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fcm_token': fcmToken,
        }),
      );

      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');
    }

    @override
    Widget build(BuildContext context) {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            if (!_tokenSent) {
              _tokenSent = true;
              sendFcmToken();
            }
            return const HomePage();
          }

          _tokenSent = false;
          return const SplashPage();
        },
      );
    }
  }
