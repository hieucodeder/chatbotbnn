import 'package:flutter/material.dart';

class SelectedHistoryProvider extends ChangeNotifier {
  String? _selectedChatId;

  String? get selectedChatId => _selectedChatId;

  void setSelectedChatId(String chatId) {
    _selectedChatId = chatId;
    notifyListeners(); // Cập nhật UI
  }
}
