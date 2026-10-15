import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static bool isSoundOn = true;
  static bool _isBgmPlaying = false;

  // --- EFECTOS DE SONIDO (SFX) ---
  static Future<void> _playSound(String path) async {
    if (!isSoundOn) return;
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

  // --- MÚSICA DE FONDO EN BUCLE (BGM) ---
  static Future<void> startBgm() async {
    if (!isSoundOn || _isBgmPlaying) return;
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
    if (!isSoundOn) {
      await stopBgm();
      await _sfxPlayer.stop();
    } else {
      await startBgm();
    }
  }
}