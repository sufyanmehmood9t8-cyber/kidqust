import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> init() async {
    await _flutterTts.setLanguage("ur-PK");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.4); // Slightly slower for better Urdu clarity
  }

  Future<void> setLanguage(String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
  }

  Future<void> speak(String text, {String? languageCode}) async {
    if (languageCode != null) {
      await _flutterTts.setLanguage(languageCode);
    }
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
