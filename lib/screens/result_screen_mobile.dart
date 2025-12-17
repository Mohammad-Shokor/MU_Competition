import 'dart:developer';

import 'package:codit_competition/screens/default_Competition_Start_Screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase/supabase.dart';

class ResultsScreenMobile extends StatefulWidget {
  const ResultsScreenMobile({
    super.key,
    required this.score,
    required this.name,
    this.Background = "assets/Background.json",
  });

  final int score;
  final String name;
  final String Background;
  @override
  State<ResultsScreenMobile> createState() => _ResultsScreenMobileState();
}

class _ResultsScreenMobileState extends State<ResultsScreenMobile> {
  final supabase = SupabaseClient(
    'https://ilqgkzpjerddesusoakh.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlscWdrenBqZXJkZGVzdXNvYWtoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUwNDc1MjYsImV4cCI6MjA4MDYyMzUyNn0.J69owVnVbKuO8_IfLgWrauWfLZ3UaLVvYrTjSRO3lVA',
  );

  List<dynamic> topPlayers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _saveAndLoad();
  }

  /// 🔥 FIRST insert → THEN load top 10
  Future<void> _saveAndLoad() async {
    await _addContestant();
    await _loadTopTen();
  }

  /// 🔥 Insert new contestant
  Future<void> _addContestant() async {
    try {
      await supabase.from('Contestants').insert({
        'Name': widget.name,
        'Score': widget.score,
      });

      log("Contestant added successfully!");
    } catch (e) {
      print("Error inserting contestant: $e");
    }
  }

  /// 🔥 Load top 10 from Supabase
  Future<void> _loadTopTen() async {
    try {
      final response = await supabase
          .from('Contestants')
          .select()
          .order('Score', ascending: false)
          .limit(10);

      setState(() {
        topPlayers = response;
        loading = false;
      });
    } catch (e) {
      log("Error loading leaderboard: $e");
      setState(() => loading = false);
    }
  }

  /// 🥇🥈🥉 Medal based on rank
  Widget _medal(int index) {
    if (index == 0) {
      return const Text("🥇", style: TextStyle(fontSize: 26));
    } else if (index == 1) {
      return const Text("🥈", style: TextStyle(fontSize: 26));
    } else if (index == 2) {
      return const Text("🥉", style: TextStyle(fontSize: 26));
    }
    return Text(
      "${index + 1}.",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Lottie.asset(
                    widget.Background,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: SizedBox(
                      width: width > 700 ? width * 0.6 : double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 60),

                          /// 🔥 TITLE
                          Text(
                            "Top Contestants",
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width > 700 ? 60 : 34,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// 🔥 Leaderboard List
                          Expanded(
                            child: ListView.builder(
                              itemCount: topPlayers.length,
                              itemBuilder: (context, index) {
                                final player = topPlayers[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 20,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 5, 59, 104),
                                          Colors.blue,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 6,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        /// 🥇 Medal or numbering
                                        Row(
                                          children: [
                                            _medal(index),
                                            const SizedBox(width: 10),
                                            Text(
                                              player['Name'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Text(
                                          player['Score'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// 🔙 Back Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DefaultCompetitionStartScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Go back to start",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
