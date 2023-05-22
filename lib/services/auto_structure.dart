import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:ml_utility/services/shopify_api.dart';

import '../ChatGPT/chatbot/screens/error_screen.dart';
import '../ChatGPT/providers/chat_provider.dart';
import '../ChatGPT/services/network_helper.dart';

final chatProvider = ChatProvider();

Future<void> auto_structure(
    {required BuildContext context, required String text}) async {
  var data = {
    "product": {
      "title": "Your Product Name",
      "body_html": "<strong>Your Product Description</strong>",
      "vendo": "Your Vendor Name",
      "product_type": "Your Product Type",
      "tags": "Your Product, Tags",
    }
  };
  var shopify_structure = '''
[${data.toString()}]
  ''';

  try {
    String prompt = "in a valid json, "
        "please structure the following:\n${text}\nin this structure:\n${shopify_structure},";
    print('prompt $prompt');
    chatProvider.addMessage(
      message: prompt,
      role: "system",
    );

    bool status = await NetworkHelper.chatQuery(
        listData: chatProvider.getChatList,
        chatProvider: chatProvider,
        context: context);

    if (!status) {
      throw const HttpException("Error");
    }
  } catch (error) {
    log(error.toString());
    chatProvider.initList();
    const ErrorScreen();
  } finally {
    final response = chatProvider.chatList.last;
    print('structured content ${response.content}');
    await shopify_create_products(response.content);
  }
}
