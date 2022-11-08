import 'package:flutter/material.dart';

import '../models/question.dart';

///[SurveyFormField], a [StatelessWidget] that is composed of a [FormField] widget.
///Serves as the base widget for all FormFields of the Survey.
class SurveyFormField extends StatelessWidget {
  ///A parameter contains all the information about a particular question passed as a [Question] object.
  final Question question;

  ///An optional method to call with the final value when the form is saved via FormState.save.
  final FormFieldSetter<List<String>>? onSaved;

  ///An optional method that validates an input. Returns an error string to display if the input is invalid, or null otherwise.
  final FormFieldValidator<List<String>>? validator;

  ///Used to configure the auto validation of FormField and Form widgets.
  final AutovalidateMode? autovalidateMode;

  ///Used to configure the default errorText for the validator.
  final String defaultErrorText;

  ///Function that returns the widget representing this form field. It is passed the form field state as input, containing the current value and validation state of this field.
  final Widget Function(FormFieldState<List<String>> state) builder;
  const SurveyFormField({
    Key? key,
    required this.question,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    required this.builder,
    required this.defaultErrorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
        onSaved: onSaved,
        validator: (validator == null && question.isMandatory)
            ? (List<String>? answer) {
                if (answer!.isEmpty) return defaultErrorText;
                return null;
              }
            : validator,
        initialValue: question.answers,
        autovalidateMode: autovalidateMode,
        builder: builder);
  }
}
