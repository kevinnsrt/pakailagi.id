import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/authentication/token.dart';

class GetUserCart {
   Future<dynamic> getusercart() async {
     final user = FirebaseAuth.instance;
    final token = await UserToken().getToken();

    if(user != null){
      final uid = user.currentUser!.uid.toString();

      if (token == null) {
        print("Token null, user belum login");
      }
      final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/carts/user");

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
      var data = json.decode(response.body);

      print(data);

      if (data is List) {
        return data;
      } else if (data is Map) {
        return [data];
      } else {
        return [];
      }

    }
    }
}