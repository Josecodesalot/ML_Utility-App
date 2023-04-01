import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ml_utility/ChatGPT/constants/api_constants.dart';
import 'package:ml_utility/ChatGPT/providers/chat_provider.dart';

import '../constants/auth.dart';

class NetworkHelper {
  static Future<bool> chatQuery(
      List<Map<String, dynamic>> listData, ChatProvider chatProvider) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completionss"),
        headers: {
          "Authorization": "Bearer $OPENAI_API_KEY",
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {"model": "gpt-3.5-turbo", "messages": listData},
        ),
      );
      log("test");
      Map jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        chatProvider.addMessage(
          role: 'assistant',
          message: jsonResponse["choices"][0]["message"]["content"],
        );
        return true;
      } else {
        throw HttpException(jsonResponse["error"]["message"]);
      }
    } catch (error) {
      log("Network Helper");
      log(error.toString());

      return false;
    }
  }
}
