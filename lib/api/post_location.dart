import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/authentication/token.dart';

class PostLocation{
  static Future<Map<String,dynamic>> postLocation({
    required double lat,
    required double lng,
})async{
    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/update/location");
    final token = await UserToken().getToken();
    final uid = await FirebaseAuth.instance.currentUser!.uid;
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "id": uid,
        "latitude":lat,
        "longitude":lng
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Backend error: ${response.body}");
    }
    // Jika sukses
    return json.decode(response.body);
  }
}
