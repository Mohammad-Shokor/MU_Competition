import 'package:codit_competition/questions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/InitialiseUsers.dart';
import 'teams.dart';

/// ------------------ SCREEN 1 ------------------
class QuestionSourceScreen extends StatelessWidget {
  const QuestionSourceScreen({
    super.key,
    required this.size,
    required this.Background,
  });
  final int size;
  final String Background;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            Background,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              width: width > 600 ? 400 : width * 0.9,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Choose Question Source",
                    style: GoogleFonts.aBeeZee(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _optionButton(
                    context,
                    title: "Use Premade Questions",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) {
                            return PreMadeQuestions(
                              size: size,
                              chosenBackground: Background,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  _optionButton(
                    context,
                    title: "Create My Own Questions",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CustomQuestionsScreen(
                                chosenBackground: Background,
                                size: size,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionButton(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.aBeeZee(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PreMadeQuestions extends StatelessWidget {
  const PreMadeQuestions({
    super.key,
    required this.size,
    required this.chosenBackground,
  });
  final int size;
  final String chosenBackground;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            chosenBackground,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              width: width > 600 ? 400 : width * 0.9,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Choose Question Source",
                    style: GoogleFonts.aBeeZee(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _optionButton(
                    context,
                    title: "Computer Science Questions",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) {
                            return TeamInputScreen(
                              competition: Club.Code_it,
                              size: size,
                              questions: csQuestions,
                              answers: csAnswers,
                              Background: chosenBackground,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  _optionButton(
                    context,
                    title: "Business Questions",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) {
                            return TeamInputScreen(
                              competition: Club.MUBC,
                              size: size,
                              questions: businessQuestions,
                              answers: businessAnswers,
                              Background: chosenBackground,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  _optionButton(
                    context,
                    title: "General Questions",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) {
                            return TeamInputScreen(
                              competition: Club.Mix,
                              size: size,
                              questions: generalQuestions,
                              answers: generalAnswers,
                              Background: chosenBackground,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionButton(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.aBeeZee(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// ------------------ MODEL ------------------
class CustomQuestion {
  final String question;
  final List<String> answers; // answers[0] is correct

  CustomQuestion({required this.question, required this.answers});
}

/// ------------------ SCREEN 2 ------------------
class CustomQuestionsScreen extends StatefulWidget {
  const CustomQuestionsScreen({
    super.key,
    required this.chosenBackground,
    required this.size,
  });
  final String chosenBackground;
  final int size;
  @override
  State<CustomQuestionsScreen> createState() => _CustomQuestionsScreenState();
}

class _CustomQuestionsScreenState extends State<CustomQuestionsScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _answerControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<CustomQuestion> _questions = [];

  void _addQuestion() {
    final question = _questionController.text.trim();
    final answers = _answerControllers.map((c) => c.text.trim()).toList();

    if (question.isEmpty || answers.any((a) => a.isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      _questions.add(CustomQuestion(question: question, answers: answers));
      _questionController.clear();
      for (final c in _answerControllers) {
        c.clear();
      }
    });
  }

  void _continue() {
    // Collect all answers
    final List<List<String>> answers =
        _questions.map((q) => q.answers).toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return TeamInputScreen(
            competition: Club.Custom,
            questions: _questions.map((q) => q.question).toList(),
            answers: answers,
            size: widget.size,
            Background: widget.chosenBackground,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Questions"),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              _continue();
            },
            child: Text("Continue"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: width * 0.7,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Question Card
                      _sectionCard(
                        title: "Question",
                        child: TextField(
                          controller: _questionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "Enter your question here...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Answers Card
                      _sectionCard(
                        title: "Answers",
                        subtitle: "First answer is the correct one",
                        child: Column(
                          children: List.generate(4, (i) {
                            final isCorrect = i == 0;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextField(
                                controller: _answerControllers[i],
                                decoration: InputDecoration(
                                  labelText:
                                      isCorrect
                                          ? "Correct Answer"
                                          : "Answer ${i + 1}",
                                  prefixIcon: Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    color:
                                        isCorrect ? Colors.green : Colors.grey,
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Add Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addQuestion,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Question"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                _questions.isEmpty
                    ? Container()
                    : Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),

                          /// Added Questions Preview
                          if (_questions.isNotEmpty) ...[
                            Text(
                              "Added Questions (${_questions.length})",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ..._questions.map(
                              (q) => Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.help_outline),
                                  title: Text(q.question),
                                  subtitle: Text("Correct: ${q.answers[0]}"),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          /// Preview Button
                          if (_questions.isNotEmpty)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => QuestionsPreviewScreen(
                                            questions: _questions,
                                          ),
                                    ),
                                  );
                                },
                                child: const Text("Preview Questions"),
                              ),
                            ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable Section Card
  Widget _sectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// ------------------ SCREEN 3 ------------------
class QuestionsPreviewScreen extends StatelessWidget {
  final List<CustomQuestion> questions;

  const QuestionsPreviewScreen({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Questions Preview"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          q.question,
                          style: GoogleFonts.aBeeZee(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Answers
                  ...List.generate(q.answers.length, (i) {
                    final isCorrect = i == 0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isCorrect
                                ? Colors.green.withOpacity(0.12)
                                : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCorrect ? Colors.green : Colors.transparent,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCorrect
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 20,
                            color: isCorrect ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              q.answers[i],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isCorrect
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
