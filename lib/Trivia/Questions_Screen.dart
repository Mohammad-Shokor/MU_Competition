import 'dart:async';
import 'package:codit_competition/Trivia/oneVOneResults.dart';
import 'package:codit_competition/Trivia/teams.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../questions.dart';
import 'StartScreen.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.competitionType,
    required this.team1,
    required this.team2,
    required this.teams,
  });
  final Club competitionType;
  final String team1;
  final String team2;
  final List<Team> teams;
  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;

  late List<String> question;
  late List<List<String>> answers;
  late List<String> shownQuestions;
  late List<List<String>> shownAnswers;
  bool DarkMode = true;
  late String team1 = widget.team1;
  late String team2 = widget.team2;
  int team1Score = 0;
  int team2Score = 0;

  int _secondsRemaining = 15;
  Timer? _timer;
  int currentTeam = 1;

  // TEAM COLORS
  Color team1Color = Colors.yellow;
  Color team2Color = Colors.yellow;
  Color get ContainerColor {
    return DarkMode
        ? Colors.black.withOpacity(0.3)
        : Colors.white.withOpacity(0.18);
  }

  // bool check = true; // for second team attempts
  bool buttonsEnabled = false;
  String? selectedAnswer;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Set questions and answers based on competition type
    question =
        widget.competitionType == Club.Code_it
            ? csQuestions
            : widget.competitionType == Club.MUBC
            ? businessQuestions
            : questions;

    answers =
        widget.competitionType == Club.Code_it
            ? csAnswers
            : widget.competitionType == Club.MUBC
            ? businessAnswers
            : ListOfAnswers;

    // Shuffle questions
    shownQuestions = List.from(question);
    shownQuestions.shuffle();

    // Shuffle answers for display, keep original first element as correct
    shownAnswers =
        answers.map((answerList) {
          List<String> shuffled = List.from(answerList);
          shuffled.shuffle();
          return shuffled;
        }).toList();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    loadNextQuestion();
    startTimer();
  }

  // ----------------------------------------------------------
  // LOAD NEXT QUESTION (buttons locked 3 secs)
  // ----------------------------------------------------------
  void loadNextQuestion() {
    setState(() {
      selectedAnswer = null;
      buttonsEnabled = false;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        buttonsEnabled = true;
      });
    });
  }

  // ----------------------------------------------------------
  // FIXED TIMER
  // ----------------------------------------------------------
  void startTimer() {
    _timer?.cancel();
    _secondsRemaining = 15;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();

        // Reset team color to yellow after timeout
        if (currentTeam == 1) {
          team1Color = Colors.yellow;
        } else {
          team2Color = Colors.yellow;
        }

        setState(() {
          currentTeam = currentTeam == 1 ? 2 : 1;
        });

        if (!mounted) return;

        index++;

        if (index >= question.length) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Onevoneresults(
                    team1: team1,
                    competition: widget.competitionType,
                    team2: team2,
                    team1Score: team1Score,
                    team2Score: team2Score,
                    teams: widget.teams,
                  ),
            ),
          );
          return;
        }

        loadNextQuestion();
        startTimer();
        return;
      }

      setState(() {
        _secondsRemaining--;
      });
    });
  }

  // ----------------------------------------------------------
  // ANSWER LOGIC
  // ----------------------------------------------------------
  void answerQuestion(String answer) async {
    if (_secondsRemaining == 0) return;

    _timer?.cancel();

    setState(() {
      selectedAnswer = answer;
      buttonsEnabled = false;
    });

    // Correct answer is always the first in the original answers list
    bool isCorrect = answer == answers[index][0];

    if (isCorrect) {
      // Update team score and color
      if (currentTeam == 1) {
        team1Score++;
        team1Color = Colors.green;
      } else {
        team2Score++;
        team2Color = Colors.green;
      }

      await Future.delayed(const Duration(seconds: 2));

      index++;

      if (index >= question.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Onevoneresults(
                  team1: team1,
                  competition: widget.competitionType,
                  team2: team2,
                  team1Score: team1Score,
                  team2Score: team2Score,
                  teams: widget.teams,
                ),
          ),
        );
        return;
      }

      currentTeam = currentTeam == 1 ? 2 : 1;
      team1Color = Colors.yellow;
      team2Color = Colors.yellow;

      loadNextQuestion();
      startTimer();
      return;
    }

    // WRONG ANSWER
    if (currentTeam == 1) {
      team1Color = Colors.red;
    } else {
      team2Color = Colors.red;
    }

    await Future.delayed(const Duration(seconds: 2));

    currentTeam = currentTeam == 1 ? 2 : 1;
    index++;

    if (index >= question.length) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => Onevoneresults(
                team1: team1,
                competition: widget.competitionType,
                team2: team2,
                team1Score: team1Score,
                team2Score: team2Score,
                teams: widget.teams,
              ),
        ),
      );
      return;
    }

    team1Color = Colors.yellow;
    team2Color = Colors.yellow;
    loadNextQuestion();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // UI
  // ----------------------------------------------------------
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
          Positioned(
            top: -50,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.33),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.cyan.withOpacity(0.28), Colors.transparent],
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: width > 700 ? double.infinity : width * 0.85,
              child: SizedBox(
                child: Column(
                  children: [
                    // QUESTION
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: Duration(seconds: 1),
                          child: Container(
                            key: ValueKey(question[index]),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ContainerColor,
                              borderRadius: BorderRadius.circular(25),

                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              question[index],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aBeeZee(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width > 700 ? 40 : 28,
                              ),
                            ),
                          ),
                          // transitionBuilder: (
                          //   Widget child,
                          //   Animation<double> animation,
                          // ) {
                          //   return ScaleTransition(
                          //     scale: animation,
                          //     child: child,
                          //   );
                          // },
                        ),
                      ),
                    ),

                    // ANSWERS
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            shownAnswers[index].map((answer) {
                              return SizedBox(
                                width:
                                    width > 700 ? width * 0.48 : width * 0.85,
                                height: height * 0.07,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith((
                                          states,
                                        ) {
                                          if (answer == selectedAnswer) {
                                            bool isCorrect =
                                                answer == answers[index][0];
                                            return isCorrect
                                                ? Colors.green.withOpacity(0.8)
                                                : Colors.red.withOpacity(0.8);
                                          }
                                          if (states.contains(
                                            MaterialState.disabled,
                                          )) {
                                            return DarkMode
                                                ? Colors.black.withOpacity(0.2)
                                                : Colors.blueGrey.withOpacity(
                                                  0.3,
                                                );
                                          }
                                          return ContainerColor;
                                        }),
                                    foregroundColor:
                                        MaterialStateProperty.resolveWith((
                                          states,
                                        ) {
                                          if (states.contains(
                                            MaterialState.disabled,
                                          )) {
                                            return Colors.white.withOpacity(
                                              0.5,
                                            );
                                          }
                                          return Colors.white;
                                        }),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed:
                                      buttonsEnabled
                                          ? () => answerQuestion(answer)
                                          : null,
                                  child: AnimatedSwitcher(
                                    duration: Duration(seconds: 1),
                                    child: Text(
                                      answer,
                                      key: ValueKey(answer),
                                      style: GoogleFonts.aBeeZee(
                                        fontWeight: FontWeight.w500,
                                        fontSize: width > 700 ? 25 : 18,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    width > 700 ? Container() : SizedBox(height: 100),
                    // SCORE + TIMER
                    width > 700
                        ? Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.06,
                            ),
                            child: Row(
                              children: [
                                buildScoreCard(team1, team1Score, width),

                                const Spacer(),

                                Container(
                                  decoration: BoxDecoration(
                                    color: ContainerColor,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: width > 600 ? 0.11 * width : 100,
                                    height: width > 600 ? 0.11 * width : 100,
                                    child: Center(
                                      child: Text(
                                        _secondsRemaining > 15
                                            ? "15"
                                            : "$_secondsRemaining",
                                        style: GoogleFonts.aBeeZee(
                                          color:
                                              _secondsRemaining > 15
                                                  ? Colors.white.withOpacity(
                                                    0.3,
                                                  )
                                                  : Colors.white,

                                          fontWeight: FontWeight.bold,
                                          fontSize: width > 700 ? 90 : 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const Spacer(),
                                buildScoreCard(team2, team2Score, width),
                              ],
                            ),
                          ),
                        )
                        : Row(
                          children: [
                            buildScoreCard(team1, team1Score, width),

                            const Spacer(),

                            Container(
                              decoration: BoxDecoration(
                                color: ContainerColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: SizedBox(
                                width: width > 600 ? 0.11 * width : 100,
                                height: width > 600 ? 0.11 * width : 100,
                                child: Center(
                                  child: Text(
                                    "$_secondsRemaining",
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: width > 700 ? 90 : 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),

                            buildScoreCard(team2, team2Score, width),
                          ],
                        ),
                    SizedBox(height: height * 0.05),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => StartScreen()),
                    );
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

  // ----------------------------------------------------------
  // HELPERS
  // ----------------------------------------------------------
  Widget buildScoreCard(String team, int score, double width) {
    return width > 700
        ? Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ContainerColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 10,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: FittedBox(
                    child: Text(
                      team,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "$score",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 80,
                  ),
                ),
              ],
            ),
          ),
        )
        : Container(
          width: 100,
          decoration: BoxDecoration(
            color: ContainerColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  team,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontSize: width > 700 ? 35 : 20,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "$score",
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width > 700 ? 80 : 40,
                ),
              ),
            ],
          ),
        );
  }

  // Widget buildScoreCardThereTurn(
  //   String team,
  //   int score,
  //   Color color,
  //   double width,
  // ) {
  //   return width > 700
  //       ? Expanded(
  //         child: Container(
  //           decoration: BoxDecoration(
  //             border: Border.all(color: color, width: 10),
  //             color: ContainerColor,
  //             borderRadius: BorderRadius.circular(25),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 18),
  //                 child: FittedBox(
  //                   child: Text(
  //                     team,
  //                     textAlign: TextAlign.center,
  //                     style: GoogleFonts.aBeeZee(
  //                       color: Colors.white,
  //                       fontSize: 35,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               Text(
  //                 "$score",
  //                 textAlign: TextAlign.center,
  //                 style: GoogleFonts.aBeeZee(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 80,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       )
  //       : Container(
  //         width: 100,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: color, width: 6),
  //           color: ContainerColor,
  //           borderRadius: BorderRadius.circular(25),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               team,
  //               textAlign: TextAlign.center,
  //               style: GoogleFonts.aBeeZee(
  //                 color: Colors.white,
  //                 fontSize: width > 700 ? 35 : 20,
  //               ),
  //             ),
  //             const SizedBox(height: 5),
  //             Text(
  //               "$score",
  //               style: GoogleFonts.aBeeZee(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: width > 700 ? 80 : 40,
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  // }
}
