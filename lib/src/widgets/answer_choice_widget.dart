import 'package:flutter/material.dart';

import '../models/question.dart';

class AnswerChoiceWidget extends StatefulWidget {
  final void Function(List<String> answers) onChange;
  final Question question2;
  const AnswerChoiceWidget(
      {Key? key, required this.question2, required this.onChange})
      : super(key: key);

  @override
  State<AnswerChoiceWidget> createState() => _AnswerChoiceWidgetState();
}

class _AnswerChoiceWidgetState extends State<AnswerChoiceWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.question2.answerChoices.isNotEmpty) {
      if (widget.question2.singleChoice) {
        return SingleChoiceAnswer(
            onChange: widget.onChange, question2: widget.question2);
      } else {
        return MultipleChoiceAnswer(
            onChange: widget.onChange, question2: widget.question2);
      }
    } else {
      return SentenceAnswer(
        key: ObjectKey(widget.question2),
        onChange: widget.onChange,
        question2: widget.question2,
      );
    }
  }
}

class SingleChoiceAnswer extends StatefulWidget {
  final void Function(List<String> answers) onChange;
  final Question question2;
  const SingleChoiceAnswer(
      {Key? key, required this.onChange, required this.question2})
      : super(key: key);

  @override
  State<SingleChoiceAnswer> createState() => _SingleChoiceAnswerState();
}

class _SingleChoiceAnswerState extends State<SingleChoiceAnswer> {
  String? _selectedAnswer;
  @override
  void initState() {
    if (widget.question2.answers.isNotEmpty) {
      _selectedAnswer = widget.question2.answers.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.question2.answerChoices.keys
            .map((answer) => Row(
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
                ))
            .toList());
  }
}

class MultipleChoiceAnswer extends StatefulWidget {
  final void Function(List<String> answers) onChange;
  final Question question2;
  const MultipleChoiceAnswer(
      {Key? key, required this.onChange, required this.question2})
      : super(key: key);

  @override
  State<MultipleChoiceAnswer> createState() => _MultipleChoiceAnswerState();
}

class _MultipleChoiceAnswerState extends State<MultipleChoiceAnswer> {
  List<String> _answers = [];

  @override
  void initState() {
    _answers.addAll(widget.question2.answers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.question2.answerChoices.keys
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
  final void Function(List<String> answers) onChange;
  final Question question2;
  const SentenceAnswer(
      {Key? key, required this.onChange, required this.question2})
      : super(key: key);

  @override
  State<SentenceAnswer> createState() => _SentenceAnswerState();
}

class _SentenceAnswerState extends State<SentenceAnswer> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    if (widget.question2.answers.isNotEmpty) {
      _textEditingController.text = widget.question2.answers.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: _textEditingController,
        onFieldSubmitted: (value) {
          widget.onChange([_textEditingController.text]);
        },
      ),
    );
  }
}
