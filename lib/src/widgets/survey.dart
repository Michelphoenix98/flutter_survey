import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_survey/src/extensions/deep_copy.dart';

import '../models/question.dart';

import '../models/question_result.dart';
import 'question_card.dart';

class Survey extends StatefulWidget {
  final List<Question> initialData;
  final Widget Function(BuildContext context, Question question,
      void Function(List<String>) update)? builder;
  final void Function(List<QuestionResult> questionResults)? onNext;
  final String? defaultErrorText;
  const Survey(
      {Key? key,
      required this.initialData,
      this.builder,
      this.defaultErrorText,
      this.onNext})
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
  int _counter = 0;
  double _progress = 0;
  @override
  void initState() {
    _surveyState =
        widget.initialData.map((question) => question.clone()).toList();

    if (widget.builder != null) {
      builder = widget.builder!;
    } else {
      builder = (context, model, update) => QuestionCard(
            key: /* ValueKey(model.hashCode)*/ ObjectKey(model),
            question2: model,
            update: update,
            defaultErrorText: "This field is mandatory*",
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
  /*@override
  Widget build(BuildContext context) {
    var updatedList = widget.initialData
        .map((question) => Question.fromJson(question.toJson()))
        .toList();
    var children = _buildChildren(_surveyState, updatedList);
    print(updatedList[0].answers);
    print(_surveyState[0].answers);
    _surveyState = updatedList;
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

  List<Widget> _buildChildren(
      List<Question> questionNodes, List<Question> updatedList) {
    List<Widget> list = [];
    for (int i = 0; i < questionNodes.length; i++) {
      var child = builder(context, questionNodes[i], (List<String> value) {
        updatedList[i].answers.clear();
        updatedList[i].answers.addAll(value);
        setState(() {});
        widget.onNext?.call(++_counter);
      });
      list.add(child);
      if (_isAnswered(questionNodes[i]) &&
          _isNotSentenceQuestion(questionNodes[i])) {
        for (var answer in questionNodes[i].answers) {
          updatedList[i].answers.add(answer);
          if (_hasAssociatedQuestionList(questionNodes[i], answer)) {
            list.addAll(_buildChildren(questionNodes[i].answerChoices[answer]!,
                updatedList[i].answerChoices[answer]!));
          }
        }
      }
    }
    return list;
  }*/

  List<QuestionResult> _mapCompletionData(List<Question> questionNodes) {
    List<QuestionResult> list = [];
    for (int i = 0; i < questionNodes.length; i++) {
      if (_isAnswered(questionNodes[i])) {
        var child = QuestionResult(
            question: questionNodes[i].question,
            answers: questionNodes[i].answers);
        list.add(child);
        for (var answer in questionNodes[i].answers) {
          if (_hasAssociatedQuestionList(questionNodes[i], answer)) {
            child.children.addAll(
                _mapCompletionData(questionNodes[i].answerChoices[answer]!));
          }
        }
      }
    }
    return list;
  }

  List<Widget> _buildChildren(List<Question> questionNodes) {
    List<Widget> list = [];
    for (int i = 0; i < questionNodes.length; i++) {
      var child = builder(context, questionNodes[i], (List<String> value) {
        questionNodes[i].answers.clear();
        questionNodes[i].answers.addAll(value);
        setState(() {});
        widget.onNext?.call(_mapCompletionData(_surveyState));
      });
      list.add(child);
      if (_isAnswered(questionNodes[i]) &&
          _isNotSentenceQuestion(questionNodes[i])) {
        for (var answer in questionNodes[i].answers) {
          if (_hasAssociatedQuestionList(questionNodes[i], answer)) {
            list.addAll(
                _buildChildren(questionNodes[i].answerChoices[answer]!));
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
