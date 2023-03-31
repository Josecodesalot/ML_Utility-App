import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../services/network_helper.dart';

class ModelsProvider with ChangeNotifier {
  final List<String> models = [
    "text-davinci-003",
    "text-davinci-002",
    "text-curie-001",
    "text-babbage-001",
    "text-ada-001",
    "davinci",
    "curie",
    "babbage",
    "ada"
  ];

  int modelIndex = 0;

  List<String> get getModelList {
    return models;
  }

  String get getCurrentModel {
    return models[modelIndex];
  }

  void changeModel() {
    modelIndex++;
    notifyListeners();
  }

  Future<bool> testConnection() async {
    List<ChatModel>? msg = await NetworkHelper.postQuery(
        prompt: "Say this is a test", modelId: getCurrentModel);

    if (msg.isNotEmpty) {
      return true;
    }
    return false;
  }
}
