import 'package:codit_competition/Trivia/teams.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'InitialiseUsers.dart';

class Numberofteamsdemo extends StatefulWidget {
  const Numberofteamsdemo({super.key, required this.competition});
  final Club competition;
  @override
  State<Numberofteamsdemo> createState() => _NumberofteamsdemoState();
}

class _NumberofteamsdemoState extends State<Numberofteamsdemo> {
  int size = 1;
  bool DarkMode = true;
  final List<String> backgroundSource = [
    "assets/Background.json",
    "assets/wavyLines.json",
    "assets/Background_shooting_star.json",
  ];
  late String ChosenBackground;

  Color get containerColor {
    return DarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.white.withOpacity(0.18);
  }

  Future<void> _saveTeams() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Challenge Data saved successfully!",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 26, 133, 30),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        action: SnackBarAction(
          label: "OK",
          textColor: Colors.white,
          onPressed: () {},
        ),

        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return TeamInputScreen(
            competition: Club.Code_it,
            size: size,
            Background: ChosenBackground,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ChosenBackground = backgroundSource[0];
  }

  int selectedOption = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            ChosenBackground,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          TeamDataFillout(width, height),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Center TeamDataFillout(double width, double height) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(50),
            ),
            width: width > 700 ? width / 3 : 300,
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              children: [
                width > 700
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Number of teams:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: size,
                              dropdownColor: Colors.grey[900],
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              items:
                                  [1, 2, 4].map((teamSize) {
                                    return DropdownMenuItem<int>(
                                      value: teamSize,
                                      child: Text(
                                        "$teamSize",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() => size = value!);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                    : Container(),
                width > 700 ? Divider(color: Colors.white) : Container(),
                singleChoiceQuestion(width, height),
                ElevatedButton(
                  onPressed: _saveTeams,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        DarkMode
                            ? Colors.black.withOpacity(0.3)
                            : Colors.white.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Colors.white, // border color
                        width: 1, // border thickness
                      ),
                    ),
                  ),
                  child: Text(
                    "Start Challenge",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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

  Column singleChoiceQuestion(double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Choose a Background:",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 20),
        // Generate option buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < backgroundSource.length; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = i; // only one can be selected
                    ChosenBackground = backgroundSource[selectedOption];
                  });
                },
                child: AnimatedContainer(
                  width: width > 700 ? width / 11 : width / 8,
                  height: height / 6,
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(width > 700 ? 8 : 4),
                  decoration: BoxDecoration(
                    color:
                        selectedOption == i
                            ? Colors.blueAccent
                            : Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:
                        selectedOption == i
                            ? [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.6),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ]
                            : [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Lottie.asset(backgroundSource[i], fit: BoxFit.fill),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
