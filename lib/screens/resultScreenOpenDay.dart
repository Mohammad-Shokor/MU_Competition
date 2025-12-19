import 'dart:math';
import 'package:codit_competition/screens/competition_screen_mobile.dart';
import 'package:codit_competition/screens/default_Competition_Start_Screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:lottie/lottie.dart';
import 'package:supabase/supabase.dart';

class Resultscreenopenday extends StatefulWidget {
  const Resultscreenopenday({
    super.key,
    required this.team1Score,
    required this.team1Name,
  });
  final int team1Score;
  final String team1Name;

  @override
  State<Resultscreenopenday> createState() => _ResultscreenopendayState();
}

class _ResultscreenopendayState extends State<Resultscreenopenday> {
  final supabase = SupabaseClient(
    'https://ilqgkzpjerddesusoakh.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlscWdrenBqZXJkZGVzdXNvYWtoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwNDc1MjYsImV4cCI6MjA4MDYyMzUyNn0.J69owVnVbKuO8_IfLgWrauWfLZ3UaLVvYrTjSRO3lVA',
  );

  @override
  void initState() {
    super.initState();
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
                widget.team1Score == 1
                    ? Text(
                      "Congrats, ${widget.team1Name} won ;)",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 700 ? 80 : 40,
                      ),
                    )
                    : Text(
                      "Better Luck Next Time :)",
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
