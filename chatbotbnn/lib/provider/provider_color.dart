import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Providercolor with ChangeNotifier {
  Color _selectedColor = const Color(0xff042E4D);

  Color get selectedColor => _selectedColor;

  Providercolor() {
    _loadColorFromPrefs();
  }

  get se => null;

  void changeColor(Color color) {
    _selectedColor = color;
    notifyListeners();
    _saveColorToPrefs();
  }

  Future<void> _loadColorFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('selectedColor') ?? 0xff042E4D;
    _selectedColor = Color(colorValue);
    notifyListeners();
  }

  Future<void> _saveColorToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedColor', _selectedColor.value);
  }
}