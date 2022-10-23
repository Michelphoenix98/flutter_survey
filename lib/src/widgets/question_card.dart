import 'package:flutter/material.dart';

import '../models/question.dart';
import 'answer_choice_widget.dart';
import 'survey_form_field.dart';

class QuestionCard extends StatelessWidget {
  final Question question2;
  final void Function(List<String>) update;
  final FormFieldSetter<List<String>>? onSaved;
  final FormFieldValidator<List<String>>? validator;
  final AutovalidateMode? autovalidateMode;
  const QuestionCard(
      {Key? key,
      required this.question2,
      required this.update,
      this.onSaved,
      this.validator,
      this.autovalidateMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SurveyFormField(
        question: question2,
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
                          text: question2.question,
                          style: Theme.of(context).textTheme.bodyText1,
                          children: question2.isMandatory
                              ? [
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ]
                              : null),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 6),
                      child: AnswerChoiceWidget(
                          question2: question2,
                          onChange: (value) {
                            state.didChange(value);

                            update(value);
                          })),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                ],
              ),
            ),
          );
        });
  }
}
