import 'package:codit_competition/Trivia/CreateQuestions.dart';
import 'package:codit_competition/Trivia/InitialiseUsers.dart';
import 'package:codit_competition/Trivia/teams.dart';
import 'package:codit_competition/screens/InitialiseUsers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Createchallenge extends StatefulWidget {
  const Createchallenge({super.key});

  @override
  State<Createchallenge> createState() => _CreatechallengeState();
}

class _CreatechallengeState extends State<Createchallenge> {
  int size = 4;
  bool DarkMode = true;
  late String ChallengeName;
  final _challengeNameController = TextEditingController();
  final List<String> backgroundSource = [
    "assets/Background.json",
    "assets/wavyLines.json",
  ];
  late String ChosenBackground;

  Color get containerColor {
    return DarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.white.withOpacity(0.18);
  }

  Future<void> _saveTeams() async {
    ChallengeName = _challengeNameController.text.trim();
    if (ChallengeName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Please fill all fields",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating, // makes it float above UI
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Challenge Name saved successfully!",
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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return QuestionSourceScreen(size: size, Background: ChosenBackground);
          //  size < 4
          // ? TeamInputScreen(
          //   competition: Club.Code_it,
          //   size: size,
          //   Background: ChosenBackground,
          // )
          //     : TeamInputScreenWeb(size: size);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _challengeNameController.dispose();
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
            width: width > 700 ? 500 : 300,
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _challengeNameController,
                  maxLength: 20,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Challenge Name",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    counterStyle: TextStyle(
                      color:
                          Colors.white, // Change the color of the counter here
                      fontWeight:
                          FontWeight
                              .bold, // You can also customize other text styles
                    ),
                  ),
                ),
                Divider(color: Colors.white),
                Row(
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
                ),
                Divider(color: Colors.white),
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
                    "Save Challenge",
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
          "Choose a Background",
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
                  width: width / 8,
                  height: height / 6,
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(8),
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
                  child: ClipRect(
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
