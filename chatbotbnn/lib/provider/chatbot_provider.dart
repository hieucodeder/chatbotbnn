import 'package:flutter/material.dart';

class ChatbotProvider with ChangeNotifier {
  String? _currentChatbotCode;

  String? get currentChatbotCode => _currentChatbotCode;

  void setChatbotCode(String? code) {
    _currentChatbotCode = code;
    notifyListeners();
  }

  int _selectedIndex = -1; // Default no item selected

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
