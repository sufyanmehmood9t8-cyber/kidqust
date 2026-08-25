// ============================================================
// lib/providers/language_provider.dart
// Manages Urdu/English language toggle across the app
// ============================================================
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  bool _isUrdu = false;

  bool get isUrdu => _isUrdu;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _isUrdu = prefs.getBool('is_urdu') ?? false;
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _isUrdu = !_isUrdu;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_urdu', _isUrdu);
    notifyListeners();
  }
}
