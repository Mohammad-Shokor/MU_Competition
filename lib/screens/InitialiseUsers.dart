import 'package:codit_competition/Trivia/LeaderBoardScreen.dart';
import 'package:codit_competition/Trivia/teams.dart';
import 'package:codit_competition/screens/competition_screen_mobile.dart';
import 'package:codit_competition/screens/team1VSteam2Screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../questions.dart';

class TeamInputScreen extends StatefulWidget {
  const TeamInputScreen({
    super.key,
    required this.competition,
    this.size = 2,
    this.Background = "assets/Background.json",
    this.questions = generalQuestions,
    this.answers = generalAnswers,
  });
  final List<String> questions;
  final List<List<String>> answers;
  final Club competition;
  final int size;
  final String Background;

  @override
  State<TeamInputScreen> createState() => _TeamInputScreenState();
}

class _TeamInputScreenState extends State<TeamInputScreen> {
  final _UserNameController = TextEditingController();
  bool DarkMode = true;
  bool OpenDay = true;
  late List<TextEditingController> _teamControllers;
  late List<String> teams;

  String userName = "";

  @override
  void initState() {
    super.initState();
    _teamControllers = List.generate(
      widget.size,
      (_) => TextEditingController(),
    );
    teams = List.filled(widget.size, "");
  }

  @override
  void dispose() {
    for (final c in _teamControllers) {
      c.dispose();
    }
    _UserNameController.dispose();
    super.dispose();
  }

  Color get containerColor {
    return DarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.white.withOpacity(0.18);
  }

  // ---------------- SAVE USER NAME ----------------
  Future<void> _saveUserName() async {
    userName = _UserNameController.text.trim();

    if (userName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill the field")));
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (ctx) => CompetitionScreenMobile(
              competitionType: widget.competition,
              questions: widget.questions,
              answers: widget.answers,
              userName: userName,
              OpenDay: OpenDay,
            ),
      ),
    );
  }

  // ---------------- SAVE TEAMS ----------------
  Future<void> _saveTeams() async {
    bool hasEmpty = false;

    for (int i = 0; i < widget.size; i++) {
      teams[i] = _teamControllers[i].text.trim();
      if (teams[i].isEmpty) hasEmpty = true;
    }

    if (hasEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (ctx) =>
                widget.size == 1
                    ? CompetitionScreenMobile(
                      competitionType: widget.competition,
                      questions: widget.questions,
                      answers: widget.answers,
                      userName: userName,
                      OpenDay: OpenDay,
                    )
                    : widget.size == 2
                    ? Team1vsteam2screen(
                      competition: widget.competition,
                      team1: teams.isNotEmpty ? teams[0] : "",
                      team2: teams.length > 1 ? teams[1] : "",
                      questions: widget.questions,
                      answers: widget.answers,
                    )
                    : Leaderboardscreen(
                      custom: true,
                      teams: [
                        Team([], teams[0], widget.competition, 0),
                        Team([], teams[1], widget.competition, 0),
                        Team([], teams[2], widget.competition, 0),
                        Team([], teams[3], widget.competition, 0),
                      ],
                      questions: widget.questions,
                      answers: widget.answers,
                    ),
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            widget.Background,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          width > 700 ? TeamDataFillout(width) : UserNameDataFillout(width),
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

  // ---------------- USERNAME ----------------
  Center UserNameDataFillout(double width) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: width > 700 ? 400 : 300,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 25,
          children: [
            Row(
              children: [
                Text(
                  "OpenDay:",
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<bool>(
                      value: OpenDay,
                      dropdownColor: Colors.grey[900],
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      items:
                          [true, false].map((openday) {
                            return DropdownMenuItem<bool>(
                              value: openday,
                              child: Text(
                                openday ? "True" : "False",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() => OpenDay = value!);
                      },
                    ),
                  ),
                ),
              ],
            ),
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                side: const BorderSide(color: Colors.white, width: 1),
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
    );
  }

  Center TeamDataFillout(double width) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: width > 700 ? 400 : 300,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(widget.size, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  controller:
                      widget.size == 1
                          ? _UserNameController
                          : _teamControllers[index],
                  maxLength: 14,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Team ${index + 1}",
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    counterStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: widget.size == 1 ? _saveUserName : _saveTeams,
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
                  side: const BorderSide(color: Colors.white, width: 1),
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
    );
  }
}
