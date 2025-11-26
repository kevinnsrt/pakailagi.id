import 'dart:convert';
import 'package:http/http.dart' as http;

class GetAllItems{

  get () async {
    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/products");

    final response = await http.get(url);

    if(response.statusCode != 200){
      print("gagal mengambil data");
    }

    if(response.statusCode == 200){
      return json.decode(response.body);
    }
  }
}