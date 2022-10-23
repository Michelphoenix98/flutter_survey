import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'question.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Question extends Equatable {
  final String question;
  final bool singleChoice;
  final Map<String, List<Question>?> answerChoices;
  final bool isMandatory;
  late final List<String> answers;

  Question(
      {required this.question,
      this.singleChoice = true,
      Map<String, List<Question>?>? answerChoices,
      this.isMandatory = false,
      List<String>? answers})
      : answers = answers ?? [],
        answerChoices = answerChoices ?? {};

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @override
  List<Object?> get props =>
      [question, singleChoice, answerChoices, isMandatory];
}
