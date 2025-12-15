import 'dart:async';
import 'package:codit_competition/Trivia/teams.dart';
import 'package:codit_competition/screens/default_Competition_Start_Screen.dart';
import 'package:codit_competition/screens/result_screen_mobile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../questions.dart';

class CompetitionScreenMobile extends StatefulWidget {
  const CompetitionScreenMobile({
    super.key,
    required this.competitionType,
    required this.userName,
    this.Background = "assets/Background.json",
    this.questions = generalQuestions,
    this.answers = generalAnswers,
  });
  final Club competitionType;
  final String userName;
  final String Background;
  final List<String> questions;
  final List<List<String>> answers;
  @override
  State<CompetitionScreenMobile> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreenMobile>
    with SingleTickerProviderStateMixin {
  int index = 0;

  late List<String> question;
  late List<List<String>> answers;
  late List<String> shownQuestions;
  late List<List<String>> shownAnswers;

  late String userName = widget.userName;
  int userScore = 0;

  int _secondsRemaining = 10;
  Timer? _timer;
  int currentTeam = 1;
  Color timerColor = Colors.black.withOpacity(0.4);
  bool check = true;
  bool buttonsEnabled = false;
  String? selectedAnswer;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Set questions and answers based on competition type
    question =
        widget.competitionType == Club.Custom
            ? widget.questions
            : widget.competitionType == Club.Code_it
            ? csQuestions
            : widget.competitionType == Club.MUBC
            ? businessQuestions
            : generalQuestions;

    answers =
        widget.competitionType == Club.Custom
            ? widget.answers
            : widget.competitionType == Club.Code_it
            ? csAnswers
            : widget.competitionType == Club.MUBC
            ? businessAnswers
            : generalAnswers;

    // Shuffle questions
    shownQuestions = List.from(question);
    shownQuestions.shuffle();

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
      timerColor = Colors.black.withOpacity(0.4);
      selectedAnswer = null;
      buttonsEnabled = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
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

        setState(() {
          currentTeam = currentTeam == 1 ? 2 : 1;
          timerColor = Colors.black.withOpacity(0.4);
        });

        if (!mounted) return;

        index++;

        if (index >= question.length) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ResultsScreenMobile(name: userName, score: userScore),
            ),
          );
          return;
        }

        loadNextQuestion();
        startTimer();
        return;
      } else if (_secondsRemaining <= 6) {
        setState(() {
          double t = (6 - _secondsRemaining) / 6; // goes from 0 → 1
          timerColor =
              Color.lerp(
                Colors.black.withOpacity(0.4),
                const Color.fromARGB(255, 144, 33, 33),
                t,
              )!;
        });
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
      userScore++;

      await Future.delayed(const Duration(seconds: 2));

      index++;

      if (index >= question.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ResultsScreenMobile(name: userName, score: userScore),
          ),
        );
        return;
      }

      loadNextQuestion();
      startTimer();
      return;
    }

    await Future.delayed(const Duration(seconds: 2));

    currentTeam = currentTeam == 1 ? 2 : 1;
    index++;

    if (index >= question.length) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  ResultsScreenMobile(name: userName, score: userScore),
        ),
      );
      return;
    }

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
            widget.Background,
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
              child: Column(
                children: [
                  SizedBox(height: 50),
                  // QUESTION
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withAlpha(70),
                        width: 3,
                      ),
                    ),
                    child: Text(
                      question[index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width > 700 ? 40 : 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // ANSWERS
                  Expanded(
                    child: Column(
                      spacing: 15,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          shownAnswers[index].map((answer) {
                            return SizedBox(
                              width: width > 700 ? width * 0.48 : width * 0.85,
                              height: height * 0.07,
                              child: ElevatedButton(
                                style: ButtonStyle(
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
                                          return Colors.blueGrey.withOpacity(
                                            0.3,
                                          );
                                        }
                                        return Colors.black.withOpacity(0.4);
                                      }),
                                  foregroundColor:
                                      MaterialStateProperty.resolveWith((
                                        states,
                                      ) {
                                        if (states.contains(
                                          MaterialState.disabled,
                                        )) {
                                          return Colors.white.withOpacity(0.5);
                                        }
                                        return Colors.white;
                                      }),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                onPressed:
                                    buttonsEnabled
                                        ? () => answerQuestion(answer)
                                        : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: FittedBox(
                                    child: Text(
                                      answer,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.aBeeZee(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 21,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),

                      width: width > 600 ? 0.11 * width : 90,
                      height: width > 600 ? 0.11 * width : 90,

                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: timerColor,

                        borderRadius: BorderRadius.circular(50),
                        boxShadow:
                            timerColor != Colors.black.withOpacity(0.4)
                                ? [
                                  BoxShadow(
                                    color: Colors.redAccent.withOpacity(0.6),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ]
                                : [],
                      ),
                      child: Text(
                        "$_secondsRemaining",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aBeeZee(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          fontSize: width > 700 ? 90 : 40,
                        ),
                      ),
                    ),
                  ),

                  buildScoreCard(userName, userScore, width),
                  SizedBox(height: width * 0.1),
                ],
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
                      MaterialPageRoute(
                        builder: (context) => DefaultCompetitionStartScreen(),
                      ),
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

  Widget buildScoreCard(String name, int score, double width) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withAlpha(70), width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              width: width * 0.3,
              height: width * 0.1,
              child: FittedBox(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: VerticalDivider(
              color: Colors.white,
              thickness: 3,
              width: 20,
            ),
          ),
          Expanded(
            child: Text(
              "$score",
              textAlign: TextAlign.center,
              style: GoogleFonts.aBeeZee(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
