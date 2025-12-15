import 'dart:math';
import 'package:codit_competition/screens/default_Competition_Start_Screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:lottie/lottie.dart';
import 'package:supabase/supabase.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({
    super.key,
    required this.team1Score,
    required this.team2Score,
    required this.team1Name,
    required this.team2Name,
  });
  final int team1Score;
  final int team2Score;
  final String team1Name;
  final String team2Name;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final supabase = SupabaseClient(
    'https://ilqgkzpjerddesusoakh.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlscWdrenBqZXJkZGVzdXNvYWtoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwNDc1MjYsImV4cCI6MjA4MDYyMzUyNn0.J69owVnVbKuO8_IfLgWrauWfLZ3UaLVvYrTjSRO3lVA',
  );

  @override
  void initState() {
    super.initState();
    _saveResults();
  }

  Future<void> _saveResults() async {
    try {
      await supabase.from('teams').insert({
        'team1': widget.team1Name,
        'team2': widget.team2Name,
        'created_at': DateTime.now().toIso8601String(),
        'team1Score': widget.team1Score,
        'team2Score': widget.team2Score, // FIXED
      });
    } catch (e) {
      print("Error saving results: $e");
    }
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
                widget.team1Score != widget.team2Score
                    ? Text(
                      "Congrats, ${widget.team1Score > widget.team2Score ? widget.team1Name : widget.team2Name} won \n with a score of ${max(widget.team1Score, widget.team2Score)}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 700 ? 80 : 40,
                      ),
                    )
                    : Text(
                      "Congrats, it is a draw!!!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 700 ? 80 : 40,
                      ),
                    ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 5, 59, 104),
                        Colors.blue,
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DefaultCompetitionStartScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Go back to start",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
