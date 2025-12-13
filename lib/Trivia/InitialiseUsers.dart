import 'package:codit_competition/Trivia/CompetitionStartScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class TeamInputScreenWeb extends StatefulWidget {
  const TeamInputScreenWeb({super.key});
  @override
  State<TeamInputScreenWeb> createState() => _TeamInputScreenStateWeb();
}

class _TeamInputScreenStateWeb extends State<TeamInputScreenWeb> {
  final _UserNameController = TextEditingController();
  bool DarkMode = true;
  int size = 4;
  late List<String> teams;
  final List<TextEditingController> _teamsController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  String userName = "";

  Future<void> _saveTeams() async {
    bool temp = false;
    for (int i = 0; i < size; i++) {
      teams.add(_teamsController[i].text.trim());
      if (teams[i].isEmpty) {
        temp = true;
      }
    }
    if (temp) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Teams saved successfully!")));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return Competitionstartscreen(teamsName: teams);
        },
      ),
    );
  }

  Color get containerColor {
    return DarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.white.withOpacity(0.18);
  }

  @override
  void dispose() {
    for (int i = 0; i < size; i++) {
      _teamsController[i].dispose();
    }
    _UserNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    teams = [];
    for (int i = 0; i < size; i++) {
      teams.add("${i + 1}");
      _teamsController.add(TextEditingController());
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
          TeamDataFillout(width),
        ],
      ),
    );
  }

  Center TeamDataFillout(double width) {
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
            width: width > 700 ? 400 : 300,
            child: Column(
              spacing: 4,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...[1, 2, 3, 4].map((teamNumber) {
                  return TextField(
                    controller: _teamsController[teamNumber - 1],
                    maxLength: 14,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Team $teamNumber",
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
                            Colors
                                .white, // Change the color of the counter here
                        fontWeight:
                            FontWeight
                                .bold, // You can also customize other text styles
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
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
                    "Save Teams",
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
}
