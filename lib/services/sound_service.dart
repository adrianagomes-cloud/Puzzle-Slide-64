import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static bool isSoundOn = true;
  static bool musicEnabled = true;
  static double volume = 1.0;
  static String? _currentBgmPath;
  static bool _isBgmPlaying = false;
  static late SharedPreferences _preferences;

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    isSoundOn = _preferences.getBool('sound_enabled') ?? true;
    musicEnabled = _preferences.getBool('music_enabled') ?? true;
    volume = _preferences.getDouble('volume') ?? 1.0;

    if (volume <= 0) {
      volume = 1.0;
      await _preferences.setDouble('volume', 1.0);
    }

    await _sfxPlayer.setVolume(volume);
    await _bgmPlayer.setVolume(volume);
  }

  // --- EFECTOS DE SONIDO (SFX) ---
  static Future<void> _playSound(String path) async {
    if (!isSoundOn || volume == 0) return;
    try {
      await _sfxPlayer.stop();
      _sfxPlayer.audioCache.prefix = '';
      await _sfxPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint('Error reproduciendo SFX $path: $e');
    }
  }

  static Future<void> playCoinSound() async =>
      await _playSound('lib/assets/songs/moneda.wav');

  static Future<void> play1UpSound() async =>
      await _playSound('lib/assets/songs/1up.wav');

  static Future<void> playEnterLevelSound() async =>
      await _playSound('lib/assets/songs/enter_level_m.wav');

  static Future<void> playSettingsSound() async =>
      await _playSound('lib/assets/songs/Settings.wav');

  static Future<void> playKlickSound() async =>
      await _playSound('lib/assets/songs/Klick.wav');

  static Future<void> playPauseSound() async =>
      await _playSound('lib/assets/songs/Pause.mp3');

  // SONIDOS DE BOTONES DE DIFICULTAD
  static Future<void> playFacilSound() async =>
      await _playSound('lib/assets/songs/Mario Mushroom - QuickSounds.com.mp3');

  static Future<void> playMedioSound() async =>
      await _playSound('lib/assets/songs/burbuja.mp3');

  static Future<void> playDificilSound() async =>
      await _playSound('lib/assets/songs/dificil.mp3');

  // --- MÚSICA DE FONDO (BGM) ---
  static Future<void> startBgm() async {
    await playCustomBgm('lib/assets/songs/bgm_menu.mp3');
  }

  // MÚSICA DE LA PANTALLA CÓMO JUGAR
  static Future<void> startHowToPlayBgm() async {
    await playCustomBgm('lib/assets/songs/tutorial.mp3');
  }

  // MÚSICA EN EL JUEGO SEGÚN DIFICULTAD
  static Future<void> startInGameBgm(String difficultyName) async {
    String songPath;
    String diff = difficultyName.toUpperCase();

    if (diff.contains('DIFÍCIL') || diff.contains('DIFICIL')) {
      songPath = 'lib/assets/songs/bowser.mp3';
    } else if (diff.contains('MEDIO') || diff.contains('NORMAL')) {
      songPath = 'lib/assets/songs/mundo2.mp3';
    } else {
      songPath = 'lib/assets/songs/bgm_menu.mp3';
    }

    await playCustomBgm(songPath);
  }

  static Future<void> playCustomBgm(String path) async {
    if (!isSoundOn || !musicEnabled || volume == 0) return;

    // Si la misma canción ya se encuentra reproduciéndose, no la reinicia
    if (_isBgmPlaying && _currentBgmPath == path) return;

    try {
      await _bgmPlayer.stop();
      _bgmPlayer.audioCache.prefix = '';
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(volume);
      await _bgmPlayer.play(AssetSource(path));
      _currentBgmPath = path;
      _isBgmPlaying = true;
    } catch (e) {
      debugPrint('Error iniciando BGM $path: $e');
    }
  }

  static Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
      _isBgmPlaying = false;
      _currentBgmPath = null;
    } catch (e) {
      debugPrint('Error deteniendo BGM: $e');
    }
  }

  // BOTÓN DE SONIDO EN PANTALLA DE JUEGO
  static Future<void> toggleSoundInGame(bool enabled, String difficultyName) async {
    isSoundOn = enabled;
    await _preferences.setBool('sound_enabled', enabled);
    if (!isSoundOn) {
      await _sfxPlayer.stop();
      await stopBgm();
    } else {
      await startInGameBgm(difficultyName);
    }
  }

  static Future<void> toggleSound(bool enabled) async {
    isSoundOn = enabled;
    await _preferences.setBool('sound_enabled', enabled);
    if (!isSoundOn) {
      await _sfxPlayer.stop();
      await stopBgm();
    } else if (musicEnabled) {
      await startBgm();
    }
  }

  static Future<void> setVolume(double value) async {
    volume = value;
    await _sfxPlayer.setVolume(value);
    await _bgmPlayer.setVolume(value);
    await _preferences.setDouble('volume', value);
    if (value == 0) {
      await stopBgm();
    } else if (musicEnabled && !_isBgmPlaying && _currentBgmPath != null) {
      await playCustomBgm(_currentBgmPath!);
    } else if (musicEnabled && !_isBgmPlaying) {
      await startBgm();
    }
  }

  static Future<void> setMusicEnabled(bool enabled) async {
    musicEnabled = enabled;
    await _preferences.setBool('music_enabled', enabled);
    if (enabled) {
      if (_currentBgmPath != null) {
        await playCustomBgm(_currentBgmPath!);
      } else {
        await startBgm();
      }
    } else {
      await stopBgm();
    }
  }
}