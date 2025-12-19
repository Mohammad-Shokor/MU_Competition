import 'dart:async';
import 'dart:math';
import 'package:codit_competition/Trivia/teams.dart';
import 'package:codit_competition/screens/default_Competition_Start_Screen.dart';
import 'package:codit_competition/screens/resultScreenOpenDay.dart';
import 'package:codit_competition/screens/result_screen_mobile.dart';
import 'package:codit_competition/screens/results_screen.dart';
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
    required this.OpenDay,
  });

  final Club competitionType;
  final String userName;
  final String Background;
  final List<String> questions;
  final List<List<String>> answers;
  final bool OpenDay;

  @override
  State<CompetitionScreenMobile> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreenMobile>
    with SingleTickerProviderStateMixin {
  int index = 0;
  int userScore = 0;
  int _secondsRemaining = 20;

  Timer? _timer;
  Color timerColor = Colors.black.withOpacity(0.4);

  late List<String> question;
  late List<List<String>> answers;
  late List<String> shownQuestions;
  late List<List<String>> shownAnswers;

  bool buttonsEnabled = false;
  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    if (widget.OpenDay) index = Random().nextInt(7);
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

    shownQuestions = List.from(question)..shuffle();
    shownAnswers = answers.map((a) => List<String>.from(a)..shuffle()).toList();

    loadNextQuestion();
    startTimer();
  }

  void loadNextQuestion() {
    setState(() {
      selectedAnswer = null;
      buttonsEnabled = false;
      timerColor = Colors.black.withOpacity(0.4);
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => buttonsEnabled = true);
      }
    });
  }

  void startTimer() {
    _timer?.cancel();
    _secondsRemaining = 20;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
        nextQuestion();
        return;
      }

      if (_secondsRemaining <= 6) {
        double t = (6 - _secondsRemaining) / 6;
        timerColor =
            Color.lerp(
              Colors.black.withOpacity(0.4),
              const Color.fromARGB(255, 144, 33, 33),
              t,
            )!;
      }

      setState(() => _secondsRemaining--);
    });
  }

  void answerQuestion(String answer) async {
    if (!buttonsEnabled) return;

    _timer?.cancel();

    setState(() {
      selectedAnswer = answer;
      buttonsEnabled = false;
    });

    bool isCorrect = answer == answers[index][0];
    if (isCorrect) userScore++;

    await Future.delayed(const Duration(seconds: 3));
    if (widget.OpenDay) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => Resultscreenopenday(
                team1Score: userScore,
                team1Name: widget.userName,
              ),
        ),
      );
    }

    nextQuestion();
  }

  void nextQuestion() {
    index++;
    if (index >= question.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  ResultsScreenMobile(name: widget.userName, score: userScore),
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
    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bool isWeb = width > 700;

    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            widget.Background,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),

          width > 700
              ? Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // WEB TOP BAR
                        if (isWeb)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildTimer(isWeb),
                              buildScoreCard(widget.userName, userScore, width),
                            ],
                          ),

                        const SizedBox(height: 100),

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
                            shownQuestions[index],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isWeb ? 40 : 24,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ANSWERS
                        Expanded(
                          child:
                              isWeb
                                  ? GridView.builder(
                                    itemCount: shownAnswers[index].length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                          childAspectRatio: 4.5,
                                        ),
                                    itemBuilder:
                                        (_, i) => buildAnswerButton(
                                          shownAnswers[index][i],
                                        ),
                                  )
                                  : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children:
                                        shownAnswers[index]
                                            .map(buildAnswerButton)
                                            .toList(),
                                  ),
                        ),

                        // MOBILE TIMER + SCORE
                        if (!isWeb) ...[
                          const SizedBox(height: 10),
                          buildTimer(isWeb),
                          const SizedBox(height: 10),
                          buildScoreCard(widget.userName, userScore, width),
                        ],

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              )
              : Center(
                child: SizedBox(
                  width: width * 0.8,
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
                                  width:
                                      width > 700 ? width * 0.48 : width * 0.85,
                                  height: height * 0.07,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith((
                                            states,
                                          ) {
                                            if (answer == answers[index][0] &&
                                                selectedAnswer != null) {
                                              return Colors.green.withOpacity(
                                                0.8,
                                              );
                                            }
                                            if (answer == selectedAnswer) {
                                              return Colors.red.withOpacity(
                                                0.8,
                                              );
                                            }
                                            if (states.contains(
                                              MaterialState.disabled,
                                            )) {
                                              return Colors.blueGrey
                                                  .withOpacity(0.3);
                                            }
                                            return Colors.black.withOpacity(
                                              0.4,
                                            );
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                            color: Colors.white,
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
                      Expanded(
                        child: Column(
                          children: [
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
                                      timerColor !=
                                              Colors.black.withOpacity(0.4)
                                          ? [
                                            BoxShadow(
                                              color: Colors.redAccent
                                                  .withOpacity(0.6),
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

                                    fontSize: width > 700 ? 60 : 40,
                                  ),
                                ),
                              ),
                            ),

                            buildScoreCard(widget.userName, userScore, width),
                          ],
                        ),
                      ),

                      SizedBox(height: width > 700 ? 50 : width * 0.08),
                    ],
                  ),
                ),
              ),

          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DefaultCompetitionStartScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGETS =================

  Widget buildTimer(bool isWeb) {
    final double size = isWeb ? 110 : 90;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
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
                  ),
                ]
                : [],
      ),
      child: Text(
        "$_secondsRemaining",
        style: GoogleFonts.aBeeZee(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: isWeb ? 50 : 36,
        ),
      ),
    );
  }

  Widget buildAnswerButton(String answer) {
    return ElevatedButton(
      onPressed: buttonsEnabled ? () => answerQuestion(answer) : null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (answer == answers[index][0] && selectedAnswer != null) {
            return Colors.green.withOpacity(0.8);
          }
          if (answer == selectedAnswer) {
            return Colors.red.withOpacity(0.8);
          }
          return Colors.black.withOpacity(0.4);
        }),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      child: Text(
        answer,
        textAlign: TextAlign.center,
        style: GoogleFonts.aBeeZee(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget buildScoreCard(String name, int score, double width) {
    return width > 700
        ? Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withAlpha(70), width: 3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  name,
                  style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 50),
                ),
              ),
              const SizedBox(
                height: 50,
                child: VerticalDivider(
                  color: Colors.white,
                  thickness: 2,
                  width: 20,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "$score",
                  style: GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
              ),
            ],
          ),
        )
        : Container(
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
                  width: width > 700 ? width * 0.1 : width * 0.3,
                  height: width > 700 ? width * 0.03 : width * 0.1,
                  child: FittedBox(
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontSize: 16,
                      ),
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
