import 'package:flutter/material.dart';

import '../utils/question.dart';
import '../utils/quiz.dart';

import '../UI/answer_button.dart';
import '../UI/question_text.dart';
import '../UI/correct_wrong_overlay.dart';

import './score_page.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("In Football, the defenders can use their hands to handle the ball", false),
    new Question("A football game lasts 100minutes divided into quarters", false),
    new Question("If a player commits a major foul in football, the opposing team is awarded a corner kick", false),
    new Question("Italy won the first world cup championship", false),
    new Question("In football a proper throw in is down with both feet on the ground", true),
    new Question("In football players can receive an unlimited number of yellow cards", false),
    new Question("If the defensive team kicks a ball over the end line, the game ends", false),
  ]);
  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overlayShouldBeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column(
          // This is our main page
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)), //True button
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false)), //False button
          ],
        ),
        overlayShouldBeVisible == true
            ? new CorrectWrongOverlay(isCorrect,
             () {
               if (quiz.length == questionNumber){
                 Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)), (Route route) => route == null);
                return;
               }
                currentQuestion = quiz.nextQuestion;
                  this.setState(() {
                    overlayShouldBeVisible = false;
                    questionText = currentQuestion.question;
                    questionNumber = quiz.questionNumber;
                  });
              })
            : new Container()
      ],
    );
  }
}
