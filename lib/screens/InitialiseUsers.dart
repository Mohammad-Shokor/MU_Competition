import 'package:codit_competition/screens/LoadScreen.dart';
import 'package:codit_competition/screens/competition_screen_mobile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class TeamInputScreen extends StatefulWidget {
  const TeamInputScreen({super.key, required this.competition});
  final String competition;
  @override
  State<TeamInputScreen> createState() => _TeamInputScreenState();
}

class _TeamInputScreenState extends State<TeamInputScreen> {
  final _team1Controller = TextEditingController();
  final _team2Controller = TextEditingController();
  final _UserNameController = TextEditingController();
  bool DarkMode = true;
  String team1 = "";
  String team2 = "";
  String userName = "";
  // Make sure Supabase is initialized
  Future<void> _saveUserName() async {
    userName = _UserNameController.text.trim();
    if (userName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill the field")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("UserName saved successfully!")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return CompetitionScreenMobile(
            competitionType: widget.competition,
            userName: userName,
          );
        },
      ),
    );
  }

  Future<void> _saveTeams() async {
    team1 = _team1Controller.text.trim();
    team2 = _team2Controller.text.trim();

    if (team1.isEmpty || team2.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill both fields")));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Teams saved successfully!")));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return Loadscreen(
            competition: widget.competition,
            team1: team1,
            team2: team2,
          );
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
    _team1Controller.dispose();
    _team2Controller.dispose();
    _UserNameController.dispose();
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
          width > 700 ? TeamDataFillout(width) : UserNameDataFillout(width),
          Center(
            child: Padding(
              padding: EdgeInsets.all(width > 700 ? 40 : 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    width > 700
                        ? "Note: Team 1 will be on the Left and Team 2 will be on the Right"
                        : "", // if mobile, user does not see this text
                    textAlign: TextAlign.center,
                    style: GoogleFonts.aBeeZee(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center UserNameDataFillout(double width) {
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
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _UserNameController,
                  maxLength: 14,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "UserName",
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
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveUserName,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        DarkMode
                            ? Colors.black.withOpacity(0.4)
                            : Colors.white.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Save Name",
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
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _team1Controller,
                  maxLength: 20,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Team 1",
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
                const SizedBox(height: 20),
                TextField(
                  maxLength: 20,
                  controller: _team2Controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Team 2",
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
                const SizedBox(height: 30),
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
