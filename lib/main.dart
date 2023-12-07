import 'package:flutter/material.dart';
import 'quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const Quizzler());
}

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.grey[900],
          body: const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: QuizPage(),
            ),
          )),
    );
  }
}

List<Icon> scoreKeeper = [];
QuizBrain brain = QuizBrain();
int qIndex = 0;

Icon correctIcon = const Icon(Icons.check, color: Colors.green);
Icon wrongIcon = const Icon(Icons.close, color: Colors.red);

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {

// ADD FUNCTION FOR BUTTON ALERT!!

    void updateScorekeeper(String selection) {
      bool quizComplete = false;
      bool correctAnswer = brain.getQuestionAnswers();
      if (selection == 'True' && correctAnswer == true ||
          selection == 'False' && correctAnswer == false) {
        scoreKeeper.add(correctIcon);
      } else {
        scoreKeeper.add(wrongIcon);
      }
      if (brain.getQuestionIndex() == 12) {
        Alert(context: context,
        title: 'QUIZ COMPLETE',
        desc: 'You have completed the quiz!',
        buttons: [
          DialogButton(
            child: const Text(
            'Restart Quiz',
          ), 
          onPressed: () => Navigator.pop(context),
          ),
        ],
        ).show();
        scoreKeeper.clear();
        quizComplete = true;
      }
      setState(() {
        brain.incrementQuestionIndex();
      });
      if (quizComplete) {
        brain.restartQuiz();
      }
    }

    Padding selectionButtons(String selection, Color color) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(color),
            enableFeedback: true,
          ),
          onPressed: () {
            setState(() => updateScorekeeper(selection));
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              selection,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      );
    }

    // Actual displayed apps. Functions requiring state are above
    return Column(
      children: <Widget>[
        Expanded(
          flex: 20,
          child: Center(
            child: Text(
               brain.getQuestionText(),
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              selectionButtons('True', Colors.green),
              selectionButtons('False', Colors.red),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: scoreKeeper,
          ),
        ),
      ],
    );
  }
}
