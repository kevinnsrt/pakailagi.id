import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tubes_pm/authentication/token.dart';

class ApiServiceRegister {
  static Future<void> registerToBackend({
    required String uid,
    required String username,
    required String number,
    required String location,
    required String token,
  }) async {

    final token = await UserToken().getToken();

    if (token == null) {
      print("Token null, user belum login");
      return null;
    }

    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/firebase-register");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // kirim ID token Firebase
      },
      body: jsonEncode({
        "uid": uid,
        "username": username,
        "number": number,
        "location": location,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Backend error: ${response.body}");
    }
  }

  static Future<void> registerGooogle({
    required String uid,
    required String username,
    required String number,
    required String location,
    required String token,
  }) async {

    final token = await UserToken().getToken();

    if (token == null) {
      print("Token null, user belum login");
      return null;
    }

    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/register-google");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // kirim ID token Firebase
      },
      body: jsonEncode({
        "uid": uid,
        "username": username,
        "number": number,
        "location": location,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Backend error: ${response.body}");
    }
  }
}
