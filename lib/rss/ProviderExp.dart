import 'package:flutter/material.dart';
import 'NewsModel.dart';

class ProviderExp extends ChangeNotifier {

  String textValue = "";
  setTextValue(String newTextValue) {
    textValue = newTextValue;
    notifyListeners();
  }

    List<NewsModel> newsModels = [];
    void setNewsModel(List<NewsModel> newsModel) {
      newsModels = newsModel;
      notifyListeners();
    }

}