import 'package:firebase_auth/firebase_auth.dart';

class UserToken {
  Future<String?> getToken() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User belum login");
      return null;
    }

    final token = await user.getIdToken(true);
    return token;
  }
}
