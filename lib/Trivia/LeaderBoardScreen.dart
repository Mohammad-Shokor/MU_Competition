import 'package:codit_competition/Trivia/OneVOne.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'StartScreen.dart';
import 'multiAngledArrow.dart';
import 'teams.dart';

class Leaderboardscreen extends StatefulWidget {
  const Leaderboardscreen({super.key, required this.teams});
  final List<Team> teams;
  @override
  State<Leaderboardscreen> createState() => _LeaderboardscreenState();
}

class _LeaderboardscreenState extends State<Leaderboardscreen> {
  // Teams list
  int round = 0;
  late List<Team> teams;

  late List<Team> finalists;
  Team? winner;
  // Level 2

  late List<GlobalKey> keys; // keys for measuring widgets
  List<Offset> start = [];
  List<Offset> end = [];

  List<bool> visibleArrows = [false, false, false, false, false, false];
  @override
  void initState() {
    super.initState();

    // always clone incoming teams to avoid mutation bugs
    teams = widget.teams.map((t) => t.copy()).toList();

    // calculate round
    round = teams.fold(0, (sum, t) => sum + t.Level);

    // pick finalists
    finalists = teams.where((t) => t.Level >= 1).toList();

    // ensure 2 finalists (fallback is invisible dummy)
    if (finalists.length < 2) {
      finalists.addAll(
        List.generate(
          2 - finalists.length,
          (_) => Team([], "", Club.Code_it, -1),
        ),
      );
    }

    // pick winner
    winner = teams.firstWhere(
      (t) => t.Level == 2,
      orElse: () => Team([], "", Club.Code_it, -1),
    );

    // 4 teams + 2 finalists + 1 winner
    keys = List.generate(7, (_) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      start.clear();
      end.clear();

      for (int i = 0; i < 6; i++) {
        start.add(getCenterTop(keys[i]));
      }

      end = [
        getCenterBottom(keys[4]),
        getCenterBottom(keys[4]),
        getCenterBottom(keys[5]),
        getCenterBottom(keys[5]),
        getCenterBottom(keys[6]),
        getCenterBottom(keys[6]),
      ];

      for (int i = 0; i < 4; i++) {
        if (teams[i].Level >= 1) visibleArrows[i] = true;
      }

      for (int i = 0; i < 2; i++) {
        if (finalists[i].Level == 2) visibleArrows[i + 4] = true;
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
          Center(
            child: StartTrivia(
              context,
              round > 2
                  ? StartScreen()
                  : OneVOne(
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
          width: 100,
          height: 100,
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
            icon: Icon(Icons.play_arrow, size: 70, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
