import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Question extends Equatable {
  final String question;
  final bool singleChoice;
  final Map<String, List<Question>?> answerChoices;
  final bool isMandatory;
  final Map<String, dynamic>? properties;
  late final List<String> answers;

  Question(
      {required this.question,
      this.singleChoice = true,
      Map<String, List<Question>?>? answerChoices,
      this.isMandatory = false,
      this.properties,
      List<String>? answers})
      : answers = answers ?? [],
        answerChoices = answerChoices ?? {},
        assert(
            properties != null && answerChoices!.isEmpty || properties == null);

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @override
  List<Object?> get props =>
      [question, singleChoice, answerChoices, isMandatory];
}
