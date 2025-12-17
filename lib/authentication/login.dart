import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/authentication/authGate.dart';
import 'package:tubes_pm/authentication/token.dart';

class LoginAuth {
  // Singleton
  static final LoginAuth instance = LoginAuth._internal();
  LoginAuth._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // login
  String email = "";
  String password = "";


  login1(BuildContext context) async {
   final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
       email: email, password: password);
    print("berhasil login");

   await UserToken().getToken();

   Navigator.pushReplacement(
     context,
     MaterialPageRoute(builder: (context) => const AuthGate()),
   );


  }
}