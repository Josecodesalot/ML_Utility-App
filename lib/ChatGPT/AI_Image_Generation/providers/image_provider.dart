import 'package:flutter/material.dart';

import '../models/image_model.dart';

class AI_ImageProvider with ChangeNotifier {
  List<ImageModel> chatList = [];

  List<Map<String, String>> get getImageChatList =>
      chatList.map((e) => e.toJson()).toList();

  void addImageMessage(
      {required String prompt, required String url, required String role}) {
    chatList.add(ImageModel(prompt: prompt, url: url, role: role));
    notifyListeners();
  }

  ImageModel getQuery(int index) => chatList[index];
}
