import 'package:codit_competition/Trivia/LeaderBoardScreen.dart';
import 'package:codit_competition/Trivia/teams.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;
  List<Team> teams = [
    Team(
      ["Ali", "Mohammad", "Jawad", "Mohsen"],
      "Binary Nerds",
      Club.Code_it,
      0,
    ),
    Team(
      ["Hadi", "Mahdi", "Rami", "Youssef"],
      "Algorithm Avengers",
      Club.Code_it,
      0,
    ),
    Team(["Sara", "Lama", "Nour", "Rita"], "Market Mavericks", Club.MUBC, 0),
    Team(
      ["Omar", "Hussein", "Fadi", "Karim"],
      "Business Innovators",
      Club.MUBC,
      0,
    ),
  ];
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // Dark-themed colors
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_colorAnimation1.value!, _colorAnimation2.value!],
              ),
            ),
            child: child,
          ),
          backgroundColor: Colors.transparent,
        );
      },
      child: Center(
        child: SizedBox(
          width: width * 0.9,
          height: height - width * 0.05,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // spacing: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(75),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 75,
                      child: ClipOval(
                        child: Image.asset(
                          "assets/CodeIt.jpg",
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                  ),

                  Spacer(),

                  Text(
                    "Trivia Start Screen",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.aBeeZee(
                      fontSize: width > 700 ? 70 : 35,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(75),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 75,
                      child: ClipOval(
                        child: Image.asset(
                          "assets/MUBC.jpg",
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: width > 700 ? height * 0.2 : height * 0.1),
              SizedBox(
                width: 1000,
                child: StartTrivia(
                  context,
                  Leaderboardscreen(teams: teams),
                  width,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column StartTrivia(BuildContext context, Widget target, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width > 700 ? 150 : 60),
            border: Border.all(color: Colors.white, width: 5),
          ),
          width: width > 700 ? 300 : 150,
          height: width > 700 ? 300 : 150,
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
            icon: Icon(Icons.play_arrow, size: 200, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
