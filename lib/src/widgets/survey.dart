import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_survey/src/extensions/deep_copy.dart';

import '../models/question.dart';

import '../models/question_result.dart';
import 'question_card.dart';

///Creates a Survey form
class Survey extends StatefulWidget {
  ///The list of [Question] objects that dictate the flow and behaviour of the survey
  final List<Question> initialData;

  ///Function that returns a custom widget that is to be rendered as a field, preferably a [FormField]
  final Widget Function(BuildContext context, Question question,
      void Function(List<String>) update)? builder;

  ///An optional method to call with the questions answered so far.
  final void Function(List<QuestionResult> questionResults)? onNext;

  ///A parameter to configure the default error message to be shown when validation fails.
  final String? defaultErrorText;

  final bool scrollToLastQuestion;
  final TextStyle? questionStyle;
  final TextStyle? answerStyle;
  final int maxLines;
  final double paddingBetweenAnswers;
  final EdgeInsets questionPadding;
  final Widget? bottomWidget;
  final void Function(int answersCount)? onInit;

  const Survey(
      {Key? key,
      required this.initialData,
      this.builder,
      this.defaultErrorText,
      this.onNext,
      this.scrollToLastQuestion = false,
      this.questionStyle = null,
      this.answerStyle = null ,
      this.maxLines = 1,
      this.paddingBetweenAnswers = 4.0,
      this.questionPadding = const EdgeInsets.all(0.0),
      this.bottomWidget,
      this.onInit
      })
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
    _surveyState =
        widget.initialData.map((question) => question.clone()).toList();

    if (widget.builder != null) {
      builder = widget.builder!;
    } else {
      builder = (context, model, update) => QuestionCard(
            key: /* ValueKey(model.hashCode)*/ ObjectKey(model),
            question: model,
            update: update,
            defaultErrorText: model.errorText ??
                (widget.defaultErrorText ?? "This field is mandatory*"),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: widget.maxLines,
            answerStyle: widget.answerStyle,
            paddingBetweenAnswers: widget.paddingBetweenAnswers,
            questionPadding: widget.questionPadding,
            questionStyle: widget.questionStyle,
          );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.onInit?.call(_surveyState.first.answers.length);
    var children = _buildChildren(_surveyState);
    _setupScrollLastQuestion(children);
    if (widget.bottomWidget != null) {
      children.add(widget.bottomWidget!);
    }
    return SingleChildScrollView(
      child: Container(
          color: Color(0xFFFFFFFF),
          child: Column(
        children: children
      )),
    );


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
    ],
    );
  }

  _setupScrollLastQuestion(List<Widget> children) {
    if (widget.scrollToLastQuestion) {
      final keyToScroll = GlobalKey();
      final needToScroll = children.length > 1;
      if (needToScroll) {
        children.insert(children.length - 1, Container(key: keyToScroll));
      }
      if (needToScroll) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (keyToScroll.currentContext != null) {
            Scrollable.ensureVisible(
              keyToScroll.currentContext!,
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            );
          }
        },);
      }
    }
  }

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
