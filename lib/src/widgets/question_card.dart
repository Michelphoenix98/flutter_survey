import 'package:flutter/material.dart';

import '../models/question.dart';
import 'answer_choice_widget.dart';
import 'survey_form_field.dart';

class QuestionCard extends StatelessWidget {
  ///The parameter that contains the data pertaining to a question.
  final Question question;

  ///A callback function that must be called with answers to rebuild the survey elements.
  final void Function(List<String>) update;

  ///An optional method to call with the final value when the form is saved via FormState.save.
  final FormFieldSetter<List<String>>? onSaved;

  ///An optional method that validates an input. Returns an error string to display if the input is invalid, or null otherwise.
  final FormFieldValidator<List<String>>? validator;

  ///Used to configure the auto validation of FormField and Form widgets.
  final AutovalidateMode? autovalidateMode;

  ///Used to configure the default errorText for the validator.
  final String defaultErrorText;
  final TextStyle? questionStyle;
  final TextStyle? answerStyle;
  final int maxLines;
  final double paddingBetweenAnswers;
  final EdgeInsets questionPadding;

  const QuestionCard(
      {Key? key,
        required this.question,
        required this.update,
        this.onSaved,
        this.validator,
        this.autovalidateMode,
        required this.defaultErrorText,
        this.questionStyle = null,
        this.answerStyle = null,
        this.maxLines = 1,
        this.paddingBetweenAnswers = 4.0,
        this.questionPadding = const EdgeInsets.only(top: 12, right: 0, left: 0, bottom: 6),
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SurveyFormField(
        defaultErrorText: defaultErrorText,
        question: question,
        onSaved: onSaved,
        validator: validator,
        autovalidateMode: autovalidateMode,
        builder: (FormFieldState<List<String>> state) {
          String questionText = question.question;
          String bracketText = "";
          final style = questionStyle ?? Theme.of(context).textTheme.bodyText1;
          final isBracket = RegExp(r'\([^)]*\)').hasMatch(question.question);
          if (isBracket) {
            questionText = RegExp(r'(.+?)\s*\(').firstMatch(question.question)?.group(1) ?? "";
            final match = RegExp(r'\((.*?)\)').firstMatch(question.question);
            if (null != match) {
              bracketText = match.group(0) ?? "";
              questionText = "$questionText ";
            }
            print("rsydortest questionText: $questionText, bracket: $bracketText");
          }
          return Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: questionPadding,
                  child: RichText(
                    text: TextSpan(
                      text: questionText ?? '',
                      style: style,
                      children: [
                        if (isBracket)
                          TextSpan(
                            text: bracketText ?? '',
                            style: style?.copyWith(fontSize: (style?.fontSize ?? 12.0) - 2.0),
                          ),
                        if (question.isMandatory)
                          TextSpan(
                            text: "*",
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: AnswerChoiceWidget(
                    paddingBetweenAnswers: paddingBetweenAnswers,
                    answerStyle: answerStyle ?? TextStyle(),
                    maxLines: maxLines,
                    question: question,
                    onChange: (value) {
                      state.didChange(value);

                      update(value);
                    })),
                if (state.hasError)
                  Text(
                    state.errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          );
        });
  }
}
