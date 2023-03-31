import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ml_utility/ChatGPT/constants/api_constants.dart';
import 'package:ml_utility/ChatGPT/models/chat_model.dart';

import '../constants/auth.dart';

class NetworkHelper {
  static Future<List<ChatModel>> postQuery(
      {required String prompt, required String modelId}) async {
    List<ChatModel> chatList = [];
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          "Authorization": "Bearer $OPENAI_API_KEY",
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": prompt,
            "max_tokens": 20,
            "temperature": 0.4,
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
              message: jsonResponse["choices"][index]["text"], chatIndex: 1),
        );
        return chatList;
      } else {
        throw HttpException(jsonResponse["error"]["message"]);
      }
    } catch (error) {
      log(error.toString());
    }
    return chatList;
  }
}
