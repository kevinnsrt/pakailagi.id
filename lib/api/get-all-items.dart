import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/authentication/token.dart';

class GetAllItems {
  Future<dynamic> get() async {
    // ambil token dulu
    final token = await UserToken().getToken();

    if (token == null) {
      print("Token null, user belum login");
      return null;
    }

    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/products");

    print("TOKEN DIPAKAI:");
    print(token);

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      print("Gagal mengambil data: ${response.body}");
      return null;
    }

    return json.decode(response.body);
  }
}
