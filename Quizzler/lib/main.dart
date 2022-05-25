import 'package:flutter/material.dart';
import 'queBank.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QueBank queBank = QueBank();

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black12,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int correctAns = 0;

  void checkAnswer(bool userAnswer) {
      setState(() {
        if(queBank.hasEnded()==true){
          Alert(
            context: context,
            type: AlertType.info,
            title: "End of Quiz",
            desc: "Your Score = $correctAns",
            buttons: [
              DialogButton(
                child:const Text(
                  "Restart",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: (){
                  Navigator.pop(context);
                  setState(() {
                    queBank.clear();
                    scoreKeeper = [];
                    correctAns=0;
                  });
                },
                width: 120,
              )
            ],
          ).show();
        }
        else {
          bool correct = queBank.queAns();
          if (correct == userAnswer) {
            scoreKeeper.add(
              const Icon(Icons.check, color: Colors.green),
            );
            correctAns++;
          }
          else{
            scoreKeeper.add(
              const Icon(Icons.close, color: Colors.red),
            );
          }
          queBank.nextQuestion();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                queBank.queText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              onPressed: () {
                  checkAnswer(true);
              },
              child: const Text(
                'True',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade600,
              ),
              onPressed: () {
                  checkAnswer(false);
              },
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}
