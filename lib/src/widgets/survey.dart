import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/material.dart';

import '../models/question.dart';

import 'question_card.dart';

class Survey extends StatefulWidget {
  final List<Question> initialData;
  final Widget Function(BuildContext context, Question question,
      void Function(List<String>) update)? builder;
  const Survey({Key? key, required this.initialData, this.builder})
      : super(key: key);
  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  late List<Question> _surveyState;
  late Widget Function(
    BuildContext context,
    Question question,
    void Function(List<String>) update,
  ) builder;
  @override
  void initState() {
    _surveyState = [];
    _surveyState.addAll(widget.initialData);
    if (widget.builder != null) {
      builder = widget.builder!;
    } else {
      builder = (context, model, update) => QuestionCard(
            key: ObjectKey(model),
            question2: model,
            update: update,
          );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var children = _buildChildren(_surveyState);
    return CustomScrollView(slivers: [
      DiffUtilSliverList.fromKeyedWidgetList(
        children: children,
        insertAnimationBuilder: (context, animation, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        removeAnimationBuilder: (context, animation, child) => FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0,
            child: child,
          ),
        ),
      ),
    ]);
    //return ListView(children: children);
  }

  List<Widget> _buildChildren(List<Question> questionNodes) {
    List<Widget> list = [];
    for (int i = 0; i < questionNodes.length; i++) {
      var child = builder(context, questionNodes[i], (List<String> value) {
        questionNodes[i].answers.clear();
        questionNodes[i].answers.addAll(value);
        setState(() {});
      });
      list.add(child);
      if (_isAnswered(questionNodes[i]) &&
          _isNotSentenceQuestion(questionNodes[i])) {
        for (var answer in questionNodes[i].answers) {
          if (_hasAssociatedQuestionList(questionNodes[i], answer)) {
            list.addAll(_buildChildren(
              questionNodes[i].answerChoices[answer]!,
            ));
          }
        }
      }
    }
    return list;
  }

  bool _isAnswered(Question question) {
    return question.answers.isNotEmpty;
  }

  bool _isNotSentenceQuestion(Question question) {
    return question.answerChoices.isNotEmpty;
  }

  bool _hasAssociatedQuestionList(Question question, String answer) {
    return question.answerChoices[answer] != null;
  }
}
