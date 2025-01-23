import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  String _chatbotistoryId = '';

  String get currentIndexhistoryId => _chatbotistoryId;

  void setCurrentIndexHistoryId(String index) {
    _chatbotistoryId = index;
    notifyListeners();
  }
}
