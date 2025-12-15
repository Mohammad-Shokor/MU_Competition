import 'package:codit_competition/Trivia/startScreen.dart';
import 'package:codit_competition/screens/default_Competition_Start_Screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultCompetitionStartScreen(),
    );
  }
}
