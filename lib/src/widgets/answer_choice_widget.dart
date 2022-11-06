import 'package:flutter/material.dart';

import '../models/question.dart';

class AnswerChoiceWidget extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;

  const AnswerChoiceWidget(
      {Key? key, required this.question, required this.onChange})
      : super(key: key);

  @override
  State<AnswerChoiceWidget> createState() => _AnswerChoiceWidgetState();
}

class _AnswerChoiceWidgetState extends State<AnswerChoiceWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.question.answerChoices.isNotEmpty) {
      if (widget.question.singleChoice) {
        return SingleChoiceAnswer(
            onChange: widget.onChange, question: widget.question);
      } else {
        return MultipleChoiceAnswer(
            onChange: widget.onChange, question: widget.question);
      }
    } else {
      return SentenceAnswer(
        key: ObjectKey(widget.question),
        onChange: widget.onChange,
        question: widget.question,
      );
    }
  }
}

class SingleChoiceAnswer extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;
  const SingleChoiceAnswer(
      {Key? key, required this.onChange, required this.question})
      : super(key: key);

  @override
  State<SingleChoiceAnswer> createState() => _SingleChoiceAnswerState();
}

class _SingleChoiceAnswerState extends State<SingleChoiceAnswer> {
  String? _selectedAnswer;
  @override
  void initState() {
    if (widget.question.answers.isNotEmpty) {
      _selectedAnswer = widget.question.answers.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.question.answerChoices.keys
            .map((answer) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Radio(
                          value: answer,
                          groupValue: _selectedAnswer,
                          onChanged: (value) {
                            setState(() {
                              _selectedAnswer = value as String;
                            });
                            widget.onChange([_selectedAnswer!]);
                          }),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(answer),
                      )
                    ],
                  ),
                ))
            .toList());
  }
}

class MultipleChoiceAnswer extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;
  const MultipleChoiceAnswer(
      {Key? key, required this.onChange, required this.question})
      : super(key: key);

  @override
  State<MultipleChoiceAnswer> createState() => _MultipleChoiceAnswerState();
}

class _MultipleChoiceAnswerState extends State<MultipleChoiceAnswer> {
  late List<String> _answers;

  @override
  void initState() {
    _answers = [];
    _answers.addAll(widget.question.answers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.question.answerChoices.keys
            .map((answer) => Row(
                  children: [
                    Checkbox(
                        value: _answers.contains(answer),
                        onChanged: (value) {
                          if (value == true) {
                            _answers.add(answer);
                          } else {
                            _answers.remove(answer);
                          }
                          widget.onChange(_answers);
                          setState(() {});
                        }),
                    Text(answer)
                  ],
                ))
            .toList());
  }
}

class SentenceAnswer extends StatefulWidget {
  ///A callback function that must be called with the answer.
  final void Function(List<String> answers) onChange;

  ///The parameter that contains the data pertaining to a question.
  final Question question;
  const SentenceAnswer(
      {Key? key, required this.onChange, required this.question})
      : super(key: key);

  @override
  State<SentenceAnswer> createState() => _SentenceAnswerState();
}

class _SentenceAnswerState extends State<SentenceAnswer> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    if (widget.question.answers.isNotEmpty) {
      _textEditingController.text = widget.question.answers.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: _textEditingController,
        onChanged: (value) {
          widget.onChange([_textEditingController.text]);
        },
      ),
    );
  }
}
