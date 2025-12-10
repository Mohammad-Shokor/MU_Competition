import 'package:codit_competition/Trivia/OneVOne.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'angledArrow.dart';
import 'multiAngledArrow.dart';
import 'teams.dart';

class Leaderboardscreen extends StatefulWidget {
  const Leaderboardscreen({super.key});

  @override
  State<Leaderboardscreen> createState() => _LeaderboardscreenState();
}

class _LeaderboardscreenState extends State<Leaderboardscreen> {
  // Teams list
  int round = 0;
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

  late List<Team> finalists = [
    Team([], "", Club.Code_it, 0),
    Team([], "", Club.Code_it, 0),
  ]; // Level 1
  Team? winner; // Level 2

  late List<GlobalKey> keys; // keys for measuring widgets
  List<Offset> start = [];
  List<Offset> end = [];

  List<bool> visibleArrows = [false, false, false, false, false, false];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      round += teams[i].Level;
    }
    // Filter finalists (Level == 1)
    var temp = teams.where((team) => team.Level >= 1).toList();
    for (int i = 0; i < temp.length; i++) {
      finalists[i] = temp[i];
    }
    // Get winner (Level == 2), fallback to first team
    winner = teams.firstWhere(
      (team) => team.Level == 2,
      orElse: () => Team([], "", Club.Code_it, 0),
    );
    // Create 7 keys: 4 teams + 2 finalists + 1 winner
    keys = List.generate(7, (_) => GlobalKey());

    // Wait for layout to get positions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      start.clear();
      end.clear();

      // Start points (top center of all team widgets)
      for (int i = 0; i < 6; i++) {
        start.add(getCenterTop(keys[i]));
      }

      // End points
      for (int i = 0; i < 2; i++)
        end.add(getCenterBottom(keys[4])); // finalist 1
      for (int i = 2; i < 4; i++)
        end.add(getCenterBottom(keys[5])); // finalist 2
      for (int i = 4; i < 6; i++) end.add(getCenterBottom(keys[6])); // winner

      for (int i = 0; i < 4; i++) {
        if (teams[i].Level >= 1) {
          visibleArrows[i] = true;
        }
      }
      for (int i = 0; i < finalists.length; i++) {
        if (finalists[i].Level == 2) {
          visibleArrows[i + 4] = true;
        }
      }
    });
  }

  // Utility: Get top center of widget
  Offset getCenterTop(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return Offset.zero;
    final box = context.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    return pos + Offset(box.size.width / 2, 0);
  }

  // Utility: Get bottom center of widget
  Offset getCenterBottom(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return Offset.zero;
    final box = context.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    return pos + Offset(box.size.width / 2, box.size.height);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Update start/end offsets after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        start = keys.take(6).map(getCenterTop).toList();
        end = [
          getCenterBottom(keys[4]),
          getCenterBottom(keys[4]),
          getCenterBottom(keys[5]),
          getCenterBottom(keys[5]),
          getCenterBottom(keys[6]),
          getCenterBottom(keys[6]),
        ];
      });
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background animation
          Lottie.asset(
            "assets/Background.json",
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),

          // Finalists row
          Center(
            child: SizedBox(
              height: height - width * 0.1,
              width: 1160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 100,
                children: [
                  // Winner
                  teamContainer(6, width, winner!, 2),
                  // Finalists row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      teamContainer(4, width, finalists[0], 1),
                      SizedBox(width: 330),
                      StartTrivia(
                        context,
                        OneVOne(
                          competition:
                              round == 0
                                  ? Club.Code_it
                                  : round == 1
                                  ? Club.MUBC
                                  : Club.Mix,
                          team1:
                              round == 0
                                  ? teams[0].TeamName
                                  : round == 1
                                  ? teams[2].TeamName
                                  : finalists[0].TeamName,
                          team2:
                              round == 0
                                  ? teams[1].TeamName
                                  : round == 1
                                  ? teams[3].TeamName
                                  : finalists[1].TeamName,
                          teams: teams,
                        ),
                        width,
                      ),
                      teamContainer(5, width, finalists[1], 1),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ...teams.map((team) {
                        int idx = teams.indexOf(team);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [teamContainer(idx, width, team, 0)],
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Draw angled arrows
          CustomPaint(
            painter: MultiAngledArrowPainter(start, end, visibleArrows),
            size: Size(width, height),
          ),
        ],
      ),
    );
  }

  Container teamContainer(int idx, double width, Team team, int level) {
    // Determine opacity based on level match
    final double baseOpacity =
        (team.Level == level)
            ? 0.7
            : team.Level > level
            ? 0.2
            : 0;

    // If check == true, make it mostly transparent
    final double containerOpacity = baseOpacity;
    final double textOpacity =
        (team.Level == level)
            ? 1
            : team.Level > level
            ? 0.3
            : 0;

    return Container(
      key: keys[idx],
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900.withOpacity(containerOpacity),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(containerOpacity / 2 + 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blueGrey.shade900.withOpacity(baseOpacity),
            Colors.black.withOpacity(baseOpacity),
            Colors.blueGrey.shade800.withOpacity(baseOpacity),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      width: 250,
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          team.TeamName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            color: Colors.white70.withOpacity(textOpacity),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
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
