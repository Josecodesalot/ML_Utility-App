import 'package:flutter/material.dart';

import '../services/network_helper.dart';

class ModelsProvider with ChangeNotifier {
  List<String> models = [];
  String currentModel = "text-curie-001";
  List<String> instruct = [];

  List<String> get getModelList {
    return models;
  }

  Future<List<String>> getAllModels() async {
    models = await NetworkHelper.getModels();
    return models;
  }

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(int index) {
    currentModel = models[index];
    bool match = false;
    for (String model in instruct) {
      if (currentModel.contains(model)) {
        match = true;
        break;
      }
    }
    if (!match) {
      currentModel = "text-davinci-003";
    }
    notifyListeners();
  }
}
