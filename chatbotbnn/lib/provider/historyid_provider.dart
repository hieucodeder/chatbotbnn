import 'package:flutter/material.dart';

class HistoryidProvider with ChangeNotifier {
  // Khai báo thuộc tính chatbot_history_id
  String _chatbotHistoryId = '';

  // Getter để truy cập chatbot_history_id
  String get chatbotHistoryId => _chatbotHistoryId;

  // Setter để cập nhật chatbot_history_id và thông báo cho UI
  set chatbotHistoryId(String newId) {
    _chatbotHistoryId = newId;
    notifyListeners(); // Thông báo cho các listener rằng giá trị đã thay đổi
  }
}
