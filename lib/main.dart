import 'package:flutter/material.dart';
import 'screens/main_menu_screen.dart';
import  'screens/difficulty_selection_screen.dart';

void main() {
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