import 'package:flutter/material.dart';

import '../models/question.dart';

class SurveyFormField extends StatelessWidget {
  final Question question;
  final FormFieldSetter<List<String>>? onSaved;
  final FormFieldValidator<List<String>>? validator;
  final AutovalidateMode? autovalidateMode;
  final Widget Function(FormFieldState<List<String>> state) builder;
  SurveyFormField({
    Key? key,
    required this.question,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
        onSaved: onSaved,
        validator: (validator == null && question.isMandatory)
            ? (List<String>? answer) {
                if (answer!.isEmpty) return "This field is mandatory*";
                return null;
              }
            : validator,
        initialValue: question.answers,
        autovalidateMode: autovalidateMode,
        builder: builder);
  }
}
