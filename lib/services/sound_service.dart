import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static bool isSoundOn = true;
  static bool musicEnabled = true;
  static double volume = 1.0;
  static bool _isBgmPlaying = false;
  static late SharedPreferences _preferences;

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    isSoundOn = _preferences.getBool('sound_enabled') ?? true;
    musicEnabled = _preferences.getBool('music_enabled') ?? true;
    volume = _preferences.getDouble('volume') ?? 1.0;
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

  // 1. Moneda (Bloque ¿Cómo Jugar?)
  static Future<void> playCoinSound() async =>
      await _playSound('lib/assets/songs/moneda.wav');

  // 2. 1UP (Botón Récords)
  static Future<void> play1UpSound() async =>
      await _playSound('lib/assets/songs/1up.wav');

  // 3. Enter Level (Botón Jugar)
  static Future<void> playEnterLevelSound() async =>
      await _playSound('lib/assets/songs/enter_level_m.wav');

  // 4. Settings (Botón Opciones)
  static Future<void> playSettingsSound() async =>
      await _playSound('lib/assets/songs/Settings.wav');

  // 5. Klick (Botones de retroceso y MENÚ)
  static Future<void> playKlickSound() async =>
      await _playSound('lib/assets/songs/Klick.wav');

  // 6. Pausa (Botón PAUSA) -> Apunta a Pause.mp3
  static Future<void> playPauseSound() async =>
      await _playSound('lib/assets/songs/Pause.mp3');

// 7. Hongo / Fácil (Selección de dificultad Fácil)
  static Future<void> playFacilSound() async =>
      await _playSound('lib/assets/songs/Mario Mushroom - QuickSounds.com.mp3');
      // 8. Bowser / Difícil (Selección de dificultad Difícil)
  static Future<void> playDificilSound() async =>
      await _playSound('lib/assets/songs/dificil.wav');

  // --- MÚSICA DE FONDO EN BUCLE (BGM) ---
  static Future<void> startBgm() async {
    if (!isSoundOn || !musicEnabled || volume == 0 || _isBgmPlaying) return;
    try {
      _bgmPlayer.audioCache.prefix = '';
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.play(AssetSource('lib/assets/songs/bgm_menu.mp3'));
      _isBgmPlaying = true;
    } catch (e) {
      debugPrint('Error iniciando BGM: $e');
    }
  }

  static Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
      _isBgmPlaying = false;
    } catch (e) {
      debugPrint('Error deteniendo BGM: $e');
    }
  }

  static Future<void> toggleSound(bool enabled) async {
    isSoundOn = enabled;
    await _preferences.setBool('sound_enabled', enabled);
    if (!isSoundOn) {
      await _sfxPlayer.stop();
    }
  }

  static Future<void> setVolume(double value) async {
    volume = value;
    await _sfxPlayer.setVolume(value);
    await _bgmPlayer.setVolume(value);
    await _preferences.setDouble('volume', value);
    if (value == 0) {
      await stopBgm();
    } else if (musicEnabled) {
      await startBgm();
    }
  }

  static Future<void> setMusicEnabled(bool enabled) async {
    musicEnabled = enabled;
    await _preferences.setBool('music_enabled', enabled);
    if (enabled) {
      await startBgm();
    } else {
      await stopBgm();
    }
  }
}
