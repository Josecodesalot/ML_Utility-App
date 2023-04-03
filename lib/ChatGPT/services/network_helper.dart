import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ml_utility/ChatGPT/AI_Image_Generation/providers/image_provider.dart';
import 'package:ml_utility/ChatGPT/constants/api_constants.dart';
import 'package:ml_utility/ChatGPT/providers/chat_provider.dart';

import '../chatbot/screens/error_screen.dart';
import '../constants/auth.dart';

class NetworkHelper {
  static Future<bool> chatQuery(
      {required List<Map<String, dynamic>> listData,
      required ChatProvider chatProvider,
      required BuildContext context}) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
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
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ErrorScreen()));
      chatProvider.initList();
      return false;
    }
  }

  static Future<bool> requestImage(
      {required String prompt,
      required BuildContext context,
      required AI_ImageProvider imageProvider}) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/images/generations"),
        headers: {
          "Authorization": "Bearer $OPENAI_API_KEY",
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "prompt": prompt,
            "n": 1,
            "size": "512x512",
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw HttpException(jsonResponse["error"]["message"]);
      }

      imageProvider.addImageMessage(
        prompt: prompt,
        url: jsonResponse["data"][0]["url"],
        role: "assistant",
      );
      return true;
    } catch (error) {
      log("Network Helper");
      log(error.toString());
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ErrorScreen()));
      return false;
    }
  }
}
