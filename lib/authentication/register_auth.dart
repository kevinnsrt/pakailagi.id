
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/authentication/api_service_register.dart';
import 'package:tubes_pm/authentication/api_service_register.dart';
import 'package:tubes_pm/authentication/authGate.dart';

class RegisterAuth {

  // Singleton
  static final RegisterAuth instance = RegisterAuth._internal();
  RegisterAuth._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // register 1
  String username = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  // register 2
  String number = "";
  String location = "";

  register1() {
    print(username);
    print(email);
    print(password);
    print(confirmPassword);
  }

  register2(BuildContext context) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("berhasil sign up");

    final user = cred.user;


    if (user != null) {
      final token = await user.getIdToken();

      await ApiServiceRegister.registerToBackend(
        uid: user.uid.toString(),
        username: username.toString(),
        number: number.toString(),
        location: location.toString(),
        token: token.toString(),
      );
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthGate()),
    );
  }
}
