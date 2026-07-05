import 'package:audioplayers/audioplayers.dart';
import 'app_settings.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _bgMusicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AppSettings _settings = AppSettings();

  // A royalty-free catchy background music for kids
  static const String _bgMusicUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  Future<void> initialize() async {
    _bgMusicPlayer.setReleaseMode(ReleaseMode.loop);
    if (_settings.isMusicEnabled) {
      await startBackgroundMusic();
    }
  }

  Future<void> startBackgroundMusic() async {
    if (_settings.isMusicEnabled) {
      try {
        await _bgMusicPlayer.play(UrlSource(_bgMusicUrl));
        await _bgMusicPlayer.setVolume(0.4); // Soft background volume
      } catch (e) {
        print('Error playing background music: $e');
      }
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _bgMusicPlayer.stop();
  }

  Future<void> toggleMusic(bool enabled) async {
    if (enabled) {
      await startBackgroundMusic();
    } else {
      await stopBackgroundMusic();
    }
  }

  Future<void> playSoundEffect(String assetPath) async {
    if (_settings.isSoundEffectsEnabled) {
      try {
        await _sfxPlayer.play(AssetSource(assetPath));
      } catch (e) {
        print('Error playing sound effect: $e');
      }
    }
  }

  void dispose() {
    _bgMusicPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
