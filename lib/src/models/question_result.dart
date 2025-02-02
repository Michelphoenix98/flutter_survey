import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class QuestionResult extends Equatable {
  ///The parameter that contains the data pertaining to a question.
  final String question;

  ///The list of questions that followed after a particular answer.
  late final List<QuestionResult> children;

  ///The list of answers selected by the user.
  late final List<String> answers;

  QuestionResult({required this.question, List<String>? answers})
      : answers = answers ?? [],
        children = [];

  factory QuestionResult.fromJson(Map<String, dynamic> json) =>
      _$QuestionResultFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionResultToJson(this);

  @override
  List<Object?> get props => [question, answers, children];
}
