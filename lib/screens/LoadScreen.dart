import 'dart:async';
import 'package:codit_competition/screens/competition_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Loadscreen extends StatefulWidget {
  const Loadscreen({
    super.key,
    required this.competition,
    required this.team1,
    required this.team2,
  });
  final String competition;
  final String team1;
  final String team2;
  @override
  State<Loadscreen> createState() => _LoadscreenState();
}

class _LoadscreenState extends State<Loadscreen> {
  int _counter = 5;
  Timer? _timer;
  late String comp;
  bool DarkMode = true;
  @override
  void initState() {
    super.initState();
    _startTimer();
    comp = widget.competition;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter == 0) {
        _timer?.cancel();
        // Navigate to another screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => CompetitionScreen(
                  competitionType: comp,
                  team1: widget.team1,
                  team2: widget.team2,
                ),
          ),
        );
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            "assets/Background.json",
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color:
                    DarkMode
                        ? Colors.black.withOpacity(0.4)
                        : Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: DarkMode ? 3 : 0,
                ),
              ),
              child: SizedBox(
                width: width > 700 ? 400 : 250,
                height: width > 700 ? 400 : 250,
                child: Center(
                  child: Text(
                    "$_counter",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width > 700 ? 200 : 125,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
