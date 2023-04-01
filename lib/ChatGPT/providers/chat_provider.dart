import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<Map<String, dynamic>> get getChatList =>
      chatList.map((e) => e.toJson()).toList();

  ChatModel get getLatestQuery => chatList[chatList.length - 1];

  void addMessage({required String message, required String role}) {
    chatList.add(ChatModel(content: message, role: role));
    notifyListeners();

    log(chatList.map((e) => e.toJson()).toList().toString());
  }

  ChatModel getQuery(int index) => chatList[index];

  void initList() {
    chatList.clear();
    notifyListeners();

    log(chatList.map((e) => e.toJson()).toList().toString());
  }
}
