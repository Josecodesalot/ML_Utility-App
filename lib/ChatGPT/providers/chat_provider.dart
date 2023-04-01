import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<Map<String, dynamic>> get getChatList =>
      chatList.map((e) => e.toJson()).toList();

  void addMessage({required String message, required String role}) {
    int animateIndex = 0;
    if (role == "assistant") {
      animateIndex = 1;
    }
    chatList.add(
        ChatModel(animateIndex: animateIndex, content: message, role: role));
    if (chatList.length > 30) {
      chatList.removeAt(0);
    }
    notifyListeners();

    log(chatList.map((e) => e.toJson()).toList().toString());
  }

  void setAnimateIndex(int index) {
    chatList[index].animateIndex = 0;
  }

  ChatModel getQuery(int index) => chatList[index];

  void initList() {
    chatList.clear();
    notifyListeners();

    log(chatList.map((e) => e.toJson()).toList().toString());
  }
}
