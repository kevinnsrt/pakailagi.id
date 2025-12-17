import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/authentication/token.dart';

class NotificationService {
  // Ganti dengan URL domain API Laravel Anda
  final String baseUrl = "https://pakailagi.user.cloudjkt02.com/api/notification";

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final token = await UserToken().getToken();

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }
}