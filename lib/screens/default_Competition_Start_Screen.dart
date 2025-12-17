import 'package:codit_competition/Trivia/teams.dart';
import 'package:codit_competition/screens/NumberOfTeamsDemo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../Trivia/CreateChallenge.dart';
import 'InitialiseUsers.dart';

class DefaultCompetitionStartScreen extends StatefulWidget {
  const DefaultCompetitionStartScreen({super.key});

  @override
  State<DefaultCompetitionStartScreen> createState() =>
      _DefaultCompetitionStartScreenState();
}

class _DefaultCompetitionStartScreenState
    extends State<DefaultCompetitionStartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: Colors.black,
      end: Colors.deepPurple.shade900,
    ).animate(_controller);
    _colorAnimation2 = ColorTween(
      begin: Colors.indigo.shade900,
      end: Colors.black87,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                Text(
                  "Competition Start Screen",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(
                    fontSize: width > 700 ? 70 : 35,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: width > 700 ? height * 0.2 : height * 0.08),
                SizedBox(
                  width: 1200,
                  child:
                      width > 800
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              teamButton(
                                context,
                                Club.Code_it,
                                Lottie.asset("assets/ComputerScience2.json"),
                                Numberofteamsdemo(competition: Club.Code_it),

                                width,
                              ),
                              const Spacer(),
                              teamButton(
                                context,
                                Club.MUBC,
                                Lottie.asset("assets/Business.json"),
                                Numberofteamsdemo(competition: Club.MUBC),
                                width,
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 9,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        width > 700 ? 150 : 60,
                                      ),
                                    ),
                                    width: width > 700 ? 240 : 120,
                                    height: width > 700 ? 240 : 120,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return Numberofteamsdemo(
                                                competition: Club.Mix,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      icon: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          "assets/CSvsBusiness.png",
                                          fit: BoxFit.fitHeight,
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    clubName[Club.Mix]!,
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: width > 700 ? 30 : 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 40,
                            children: [
                              teamButton(
                                context,
                                Club.Code_it,
                                Lottie.asset("assets/ComputerScience2.json"),
                                Numberofteamsdemo(competition: Club.Code_it),
                                width,
                              ),

                              teamButton(
                                context,
                                Club.MUBC,
                                Lottie.asset("assets/Business.json"),
                                Numberofteamsdemo(competition: Club.MUBC),
                                width,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 9,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        width > 700 ? 150 : 60,
                                      ),
                                    ),
                                    width: width > 700 ? 300 : 120,
                                    height: width > 700 ? 300 : 120,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return Numberofteamsdemo(
                                                competition: Club.Mix,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      icon: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          "assets/CSvsBusiness.png",
                                          fit: BoxFit.fitHeight,
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    clubName[Club.Mix]!,
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: width > 700 ? 30 : 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton:
          width > 700
              ? FloatingActionButton.large(
                onPressed: () {
                  Navigator.push(
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
              )
              : SizedBox(
                height: 67, // 👈
                width: 67,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Createchallenge(),
                      ),
                    );
                  },
                  backgroundColor: Colors.black.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40), // keeps it round
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.edit, color: Colors.white, size: 24),
                      SizedBox(height: 4),
                      Text(
                        "Create",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Column teamButton(
    BuildContext context,
    Club title,
    Widget image,
    Widget target,
    double width,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width > 700 ? 150 : 60),
            border: Border.all(color: Colors.white, width: width > 700 ? 5 : 2),
          ),
          width: width > 700 ? 240 : 120,
          height: width > 700 ? 240 : 120,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return target;
                  },
                ),
              );
            },
            icon: image,
          ),
        ),
        Text(
          clubName[title]!,
          style: GoogleFonts.aBeeZee(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: width > 700 ? 30 : 20,
          ),
        ),
      ],
    );
  }
}

Map<Club, String> clubName = {
  Club.Code_it: "Computer Science",
  Club.MUBC: "Business",
  Club.Mix: "General Questions",
};
