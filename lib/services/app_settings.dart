import 'package:flutter/material.dart';
import 'audio_service.dart';

class AppSettings {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  bool isMusicEnabled = true;
  bool isSoundEffectsEnabled = true;
  String language = 'English'; // English | Urdu
  Color themeColor = const Color(0xFFFDE400); // Default Bright Yellow

  // For Reset Progress
  int starsCount = 0;
  int scoresCount = 0;

  // Persistence callback
  VoidCallback? onSettingsChanged;

  void updateSettings({
    bool? music,
    bool? sounds,
    String? lang,
    Color? theme,
  }) {
    if (music != null) {
      isMusicEnabled = music;
      AudioService().toggleMusic(music);
    }
    if (sounds != null) isSoundEffectsEnabled = sounds;
    if (lang != null) language = lang;
    if (theme != null) themeColor = theme;
    
    if (onSettingsChanged != null) onSettingsChanged!();
  }

  void resetProgress() {
    starsCount = 0;
    scoresCount = 0;
    if (onSettingsChanged != null) onSettingsChanged!();
  }
}
