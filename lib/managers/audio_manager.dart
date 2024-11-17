import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  bool isMuted = false;
  bool isBackgroundMusicPlaying = false;

  Future<void> initialize() async {
    // Preload all sound effects for better performance
    await FlameAudio.audioCache.loadAll([
      'jump.wav',
      'collision.wav',
      'background_music.mp3',
    ]);
  }

  void playJumpSound() {
    if (!isMuted) {
      FlameAudio.play('jump.wav', volume: 0.6);
    }
  }

  void playCollisionSound() {
    if (!isMuted) {
      FlameAudio.play('collision.wav', volume: 0.7);
    }
  }

  void playBackgroundMusic() {
    if (!isMuted && !isBackgroundMusicPlaying) {
      FlameAudio.bgm.play('background_music.mp3', volume: 0.5);
      isBackgroundMusicPlaying = true;
    }
  }

  void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
    isBackgroundMusicPlaying = false;
  }

  void toggleMute() {
    isMuted = !isMuted;
    if (isMuted) {
      stopBackgroundMusic();
    } else {
      playBackgroundMusic();
    }
  }

  void pauseBackgroundMusic() {
    if (isBackgroundMusicPlaying) {
      FlameAudio.bgm.pause();
    }
  }

  void resumeBackgroundMusic() {
    if (!isMuted && isBackgroundMusicPlaying) {
      FlameAudio.bgm.resume();
    }
  }
}
