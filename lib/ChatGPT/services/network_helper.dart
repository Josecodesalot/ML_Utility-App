import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ml_utility/ChatGPT/constants/api_constants.dart';

import '../constants/auth.dart';

class NetworkHelper {
  static Future<void> getModels() async {
    try {
      var response = await http.get(Uri.parse("$BASE_URL/models"),
          headers: {"Authorization": "Bearer $OPENAI_API_KEY"});

      Map jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var res in jsonResponse["data"]) {
          models.add(res["id"]);
        }
      } else {
        throw HttpException(jsonResponse["error"]["message"]);
      }
    } catch (error) {
      print("Error : $error");
    }
  }
}
