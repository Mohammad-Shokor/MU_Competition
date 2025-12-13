import 'package:codit_competition/Trivia/CreateChallenge.dart';
import 'package:codit_competition/Trivia/teams.dart';
import 'package:codit_competition/screens/LoadScreen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'InitialiseUsers.dart';
import 'LeaderBoardScreen.dart';

class Startscreen extends StatefulWidget {
  const Startscreen({super.key});

  @override
  State<Startscreen> createState() => _StartscreenState();
}

class _StartscreenState extends State<Startscreen> {
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
                SizedBox(height: 30),
                magicalContainer(
                  width,
                  Text(
                    "Trivia",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width > 700 ? 60 : 40,
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.4),
                  ),

                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Leaderboardscreen(
                            teams: [
                              Team(
                                ["member 1", "member 2"],
                                "Debuggers",
                                Club.Code_it,
                                0,
                              ),
                              Team(
                                ["member 1", "member 2"],
                                "Sterben",
                                Club.Code_it,
                                0,
                              ),
                              Team(
                                ["member 1", "member 2"],
                                "The Clever Crew",
                                Club.Code_it,
                                0,
                              ),
                              Team(
                                ["member 1", "member 2"],
                                "Stuckoverflow",
                                Club.Code_it,
                                0,
                              ),
                            ],
                            demo: true,
                          );
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "Try Demo",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                        Text(
                          "Trivia MUBC x Code_it; 2025",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Createchallenge();
              },
            ),
          );
        },
        backgroundColor: Colors.black.withOpacity(0.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(Icons.edit, color: Colors.white),
            Text(
              "Create your own",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Container magicalContainer(double width, Widget child) {
    return Container(
      width: width > 700 ? 300 : 200,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border.all(),
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}
