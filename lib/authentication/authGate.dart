import 'package:flutter/material.dart';
import 'package:tubes_pm/dashboard/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tubes_pm/screen/splash.dart';
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          // ApiServiceLogin();
          return const HomePage();
        }
        return const SplashPage();
      },
    );
  }
}