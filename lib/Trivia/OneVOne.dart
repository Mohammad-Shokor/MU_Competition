import 'dart:async';
import 'package:codit_competition/Trivia/Questions_Screen.dart';
import 'package:codit_competition/Trivia/teams.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OneVOne extends StatefulWidget {
  const OneVOne({
    super.key,
    required this.competition,
    required this.team1,
    required this.team2,
    required this.teams,
    this.demo = false,
  });
  final Club competition;
  final String team1;
  final String team2;
  final bool demo;
  final List<Team> teams;
  @override
  State<OneVOne> createState() => _OneVOneState();
}

class _OneVOneState extends State<OneVOne> {
  int _counter = 10;
  Timer? _timer;
  late Club comp;
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
                (context) => QuestionsScreen(
                  competitionType: comp,
                  team1: widget.team1,
                  team2: widget.team2,
                  teams: widget.teams,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.2),
                Container(
                  decoration: BoxDecoration(
                    color:
                        DarkMode
                            ? Colors.black.withOpacity(0.4)
                            : Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: DarkMode ? 3 : 0,
                    ),
                  ),

                  child: SizedBox(
                    width: width > 700 ? 130 : 100,
                    height: width > 700 ? 130 : 100,
                    child: Center(
                      child: Text(
                        "$_counter",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width > 700 ? 75 : 50,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                SizedBox(
                  width: width * 0.85,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: TeamsContainer(width, widget.team1)),
                      SizedBox(width: 150),
                      Text(
                        "VS",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 140,
                        ),
                      ),
                      SizedBox(width: 150),
                      Expanded(child: TeamsContainer(width, widget.team2)),
                    ],
                  ),
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
                ? Colors.black.withOpacity(0.3)
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
                fontSize: 70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
