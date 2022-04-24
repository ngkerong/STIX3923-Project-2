import 'package:audioplayers/audioplayers.dart';

class AudioUtils {
  static AudioPlayer? _bgAudioPlayer;
  static AudioCache? _bgAudioCache;

  static AudioCache? getBGAudioCache() {
    if (_bgAudioCache == null) {
      return _bgAudioCache = AudioCache();
    } else {
      return _bgAudioCache;
    }
  }

  static void playBgMusic() async {
      if (_bgAudioPlayer == null){
        _bgAudioPlayer =
        await getBGAudioCache()?.loop("assets/bgm/bgm.mp3", volume: 0.1);
      } else {
        _resumeBgMusic();
      }
  }

  static void pauseBgMusic() {
    _bgAudioPlayer?.pause();
  }

  static void _resumeBgMusic() {
    _bgAudioPlayer?.resume();
  }

  static disposeBGMusic() {
    _bgAudioPlayer?.dispose();
  }

  static bool isBGMusicPlaying() {
    return _bgAudioPlayer?.state == PlayerState.PLAYING;
  }
}