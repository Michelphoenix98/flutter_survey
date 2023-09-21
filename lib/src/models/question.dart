import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'question.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Question extends Equatable {
  ///The parameter that contains the data pertaining to a question.
  final String question;

  ///The parameter that indicates whether the question is a single choice or multiple choice question.
  final bool singleChoice;

  ///Used to configure the list of possible answer choices and their corresponding list of [Question] objects that follow.
  final Map<String, List<Question>?> answerChoices;

  ///If set to true the validation of the form fails if the question is left empty or doesn't satisfy a condition.
  final bool isMandatory;

  ///The default error text to be shown upon failing validation.
  final String? errorText;

  ///Custom properties for every question/field.
  final Map<String, dynamic>? properties;

  ///The list of answers selected by the user.
  late final List<String> answers;

  final TextStyle? quiestionStyle;
  final TextStyle? answerStyle;
  final int maxLines;
  final double paddingBetweenAnswers;
  final EdgeInsets questionPadding;
  Question(
      {required this.question,
      this.singleChoice = true,
      Map<String, List<Question>?>? answerChoices,
      this.isMandatory = false,
      this.errorText,
      this.properties,
      this.quiestionStyle = const TextStyle(fontSize: 19.0, color: Colors.black, fontFamily: 'sans-serif-condensed'),//tood
      this.answerStyle = const TextStyle(fontSize: 18.0, color: Colors.black, fontFamily: 'sans-serif-condensed'),//tood
      this.maxLines = 5,//todo (domyslnie 1)
      this.paddingBetweenAnswers = 1.0,
      this.questionPadding = const EdgeInsets.only(left: 4, right: 20, top: 1, bottom: 1),//todo domyslnie const EdgeInsets.only(top: 24, right: 20, left: 20, bottom: 6)
      List<String>? answers,})
      : answers = answers ?? [],
        answerChoices = answerChoices ?? {},
        assert(
            properties != null && answerChoices!.isEmpty || properties == null);

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @override
  List<Object?> get props =>
      [question, singleChoice, answerChoices, isMandatory, quiestionStyle, answerStyle, maxLines, paddingBetweenAnswers, questionPadding];
}
