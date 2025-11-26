import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tubes_pm/authentication/token.dart';

class ApiServiceLogin {
  static Future<Map<String, dynamic>> loginWithUid({
    required String uid,
  }) async {
    final token = await UserToken().getToken();

    if (token == null) {
      print("Token null, user belum login");
    }
    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "uid": uid,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Backend error: ${response.body}");
    }
    // Jika sukses
    return json.decode(response.body)[0];
  }
}
