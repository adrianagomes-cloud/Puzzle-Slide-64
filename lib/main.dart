import 'package:flutter/material.dart';
import 'screens/main_menu_screen.dart';
import 'services/record_service.dart';
import 'services/sound_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    SoundService.initialize(),
    RecordService.initialize(),
  ]);
  runApp(const PuzzleSlide64App());
}

class PuzzleSlide64App extends StatelessWidget {
  const PuzzleSlide64App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle SLiDe 64',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}
