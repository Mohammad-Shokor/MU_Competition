import 'dart:async';
import 'dart:developer';
import 'package:codit_competition/Trivia/LeaderBoardScreen.dart';
import 'package:codit_competition/Trivia/teams.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Onevoneresults extends StatefulWidget {
  const Onevoneresults({
    super.key,
    required this.competition,
    required this.team1,
    required this.team2,
    required this.teams,
    required this.team1Score,
    required this.team2Score,
  });

  final Club competition;
  final String team1;
  final String team2;
  final int team1Score;
  final int team2Score;
  final List<Team> teams;

  @override
  State<Onevoneresults> createState() => _OnevoneresultsState();
}

class _OnevoneresultsState extends State<Onevoneresults> {
  int _counter = 2;
  Timer? _timer;
  late List<Team> teams;
  bool darkMode = true;

  @override
  void initState() {
    super.initState();
    teams = widget.teams;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter == 0) {
        _timer?.cancel();

        // Determine the winner
        String winnerTeam =
            widget.team1Score >= widget.team2Score
                ? widget.team1
                : widget.team2;
        int newLevel = widget.competition == Club.Mix ? 2 : 1;

        _updateTeamLevel(winnerTeam, newLevel);
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  void _updateTeamLevel(String teamName, int newLevel) {
    final updatedTeams =
        teams.map((team) {
          if (team.TeamName == teamName) {
            return Team(
              List<String>.from(team.Members),
              team.TeamName,
              team.club,
              newLevel,
            );
          }
          return team.copy();
        }).toList();

    // Logging for debug
    String debugData = updatedTeams.map((t) => t.GetData()).join();
    log(debugData);

    // Navigate safely
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Leaderboardscreen(teams: updatedTeams),
      ),
    );
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
          // Background animation
          Lottie.asset(
            "assets/Background.json",
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),

          // Countdown timer
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.2),
                Container(
                  decoration: BoxDecoration(
                    color:
                        darkMode
                            ? Colors.black.withOpacity(0.4)
                            : Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: darkMode ? 3 : 0,
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

          // Score display
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
                      TeamsContainer(width, widget.team1),
                      SizedBox(width: 30),
                      Text(
                        "${widget.team1Score}",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width > 700 ? 110 : 90,
                        ),
                      ),
                      SizedBox(width: 30),
                      Text(
                        "${widget.team2Score}",
                        style: GoogleFonts.aBeeZee(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width > 700 ? 110 : 90,
                        ),
                      ),
                      SizedBox(width: 30),
                      TeamsContainer(width, widget.team2),
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
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
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
                fontSize: width > 700 ? 100 : 90,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
