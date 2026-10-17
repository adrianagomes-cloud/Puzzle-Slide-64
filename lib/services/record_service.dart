import 'package:shared_preferences/shared_preferences.dart';

class PuzzleRecord {
  final int seconds;
  final int moves;

  const PuzzleRecord({required this.seconds, required this.moves});
}

class RecordService {
  static late SharedPreferences _preferences;

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static PuzzleRecord? getRecord(String difficulty) {
    final seconds = _preferences.getInt(_key(difficulty, 'seconds'));
    final moves = _preferences.getInt(_key(difficulty, 'moves'));
    if (seconds == null || moves == null) return null;
    return PuzzleRecord(seconds: seconds, moves: moves);
  }

  static Future<bool> saveIfBest({
    required String difficulty,
    required int seconds,
    required int moves,
  }) async {
    final current = getRecord(difficulty);
    final isBetter = current == null ||
        seconds < current.seconds ||
        (seconds == current.seconds && moves < current.moves);
    if (!isBetter) return false;

    await Future.wait([
      _preferences.setInt(_key(difficulty, 'seconds'), seconds),
      _preferences.setInt(_key(difficulty, 'moves'), moves),
    ]);
    return true;
  }

  static String _key(String difficulty, String metric) =>
      'record_${difficulty.toLowerCase()}_$metric';
}
