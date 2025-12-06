import 'dart:convert';

import 'package:tubes_pm/authentication/token.dart';
import 'package:http/http.dart' as http;

class GetDetailsProduct {
  static Future<Map<String, dynamic>> getDetailsProduct({
    required String id,
  }) async {
    final token = await UserToken().getToken();

    if (token == null) {
      print("Token null, user belum login");
    }

    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/products/details");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({"id": id}),
    );

    if (response.statusCode != 200) {
      throw Exception("Backend Error : ${response.body}");
    }

    final body = json.decode(response.body);

    if (body is List && body.isNotEmpty) {
      print(body);
      return Map<String, dynamic>.from(body[0]);
    }

    throw Exception("Format response backend tidak sesuai (expect list berisi 1 item)");
  }
}
