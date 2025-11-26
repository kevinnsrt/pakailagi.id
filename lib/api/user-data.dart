import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServiceLogin {
  static Future<Map<String, dynamic>> loginWithUid({
    required String uid,
  }) async {

    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
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
