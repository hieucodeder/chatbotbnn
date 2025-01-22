import 'package:flutter/material.dart';

class ChatbotcolorsProvider with ChangeNotifier {
  int _selectedIndex = -1; // Default no item selected

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
