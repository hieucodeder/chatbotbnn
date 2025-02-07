import 'package:flutter/material.dart';

class HistoryidProvider with ChangeNotifier {
  String _chatbotHistoryId = '';

  String get chatbotHistoryId => _chatbotHistoryId;

  void setChatbotHistoryId(String newId) {
    _chatbotHistoryId = newId;
    notifyListeners();
  }
}
