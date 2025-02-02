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
  const QuestionCard(
      {Key? key,
      required this.question,
      required this.update,
      this.onSaved,
      this.validator,
      this.autovalidateMode,
      required this.defaultErrorText})
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
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 24, right: 20, left: 20, bottom: 6),
                    child: RichText(
                      text: TextSpan(
                          text: question.question,
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: question.isMandatory
                              ? [
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ]
                              : null),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 4, right: 20, top: 6, bottom: 6),
                      child: AnswerChoiceWidget(
                          question: question,
                          onChange: (value) {
                            state.didChange(value);

                            update(value);
                          })),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(
                    height: 12,
                  )
                ],
              ),
            ),
          );
        });
  }
}
