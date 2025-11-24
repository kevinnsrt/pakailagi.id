import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServiceRegister {
  static Future<void> registerToBackend({
    required String uid,
    required String username,
    required String number,
    required String location,
    required String token,
  }) async {

    final url = Uri.parse("http://10.168.39.176/api/firebase-register");

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
