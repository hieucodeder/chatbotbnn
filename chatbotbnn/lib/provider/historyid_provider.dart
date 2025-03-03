import 'package:flutter/material.dart';

class HistoryidProvider with ChangeNotifier {
  String _chatbotHistoryId = "";
  String _previousHistoryId = ""; // Thêm biến này

  String get chatbotHistoryId => _chatbotHistoryId;
  String get previousHistoryId => _previousHistoryId;

  void setChatbotHistoryId(String historyId) {
    _previousHistoryId = _chatbotHistoryId; // Lưu giá trị cũ
    _chatbotHistoryId = historyId;
    notifyListeners();
  }

  void resetHistoryId() {
    _chatbotHistoryId = "";
    notifyListeners();
  }

  // Thêm phương thức không gọi notifyListeners()
  void setChatbotHistoryIdWithoutNotify(String newId) {
    _chatbotHistoryId = newId;
  }
}
