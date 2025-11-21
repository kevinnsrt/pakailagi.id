
import 'package:firebase_auth/firebase_auth.dart';

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

  register2() async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("berhasil sign up");
  }
}
