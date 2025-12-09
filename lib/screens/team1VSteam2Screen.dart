import 'dart:async';
import 'package:codit_competition/screens/competition_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Team1vsteam2screen extends StatefulWidget {
  const Team1vsteam2screen({
    super.key,
    required this.competition,
    required this.team1,
    required this.team2,
  });
  final String competition;
  final String team1;
  final String team2;
  @override
  State<Team1vsteam2screen> createState() => _Team1vsteam2screenState();
}

class _Team1vsteam2screenState extends State<Team1vsteam2screen> {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
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
                    width: width > 700 ? 150 : 125,
                    height: width > 700 ? 150 : 125,
                    child: Center(
                      child: Text(
                        "$_counter",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width > 700 ? 90 : 60,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TeamsContainer(width, widget.team1),
                    SizedBox(width: 150),
                    Text(
                      "VS",
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 700 ? 150 : 90,
                      ),
                    ),
                    SizedBox(width: 150),
                    TeamsContainer(width, widget.team2),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container TeamsContainer(double width, String teamName) {
    return Container(
      padding: EdgeInsets.all(10),
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
        width: width > 700 ? 200 : 125,
        height: width > 700 ? 200 : 125,
        child: Center(
          child: FittedBox(
            child: Text(
              teamName,
              style: GoogleFonts.aBeeZee(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width > 700 ? 150 : 90,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
