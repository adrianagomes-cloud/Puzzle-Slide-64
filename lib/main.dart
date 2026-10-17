import 'package:flutter/material.dart';
import 'package:puzzle_slide_64/screens/title_screen.dart';
import 'package:puzzle_slide_64/services/record_service.dart';
import 'package:puzzle_slide_64/services/sound_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoundService.initialize();
  await RecordService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle SLiDe 64',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TitleScreen(),
    );
  }
}