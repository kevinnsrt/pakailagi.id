
import 'package:firebase_auth/firebase_auth.dart';
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

  register2() async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("berhasil sign up");

    final user = cred.user;


    if (user != null) {
      final token = await user.getIdToken();

      if (token == null) {
        throw Exception("Gagal mengambil Firebase ID Token");
      }

      await ApiServiceRegister.registerToBackend(
        uid: user.uid,
        username: username,
        number: number,
        location: location,
        token: token.toString(),
      );
    }

    return AuthGate();
  }

}
