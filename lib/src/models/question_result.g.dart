// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionResult _$QuestionResultFromJson(Map<String, dynamic> json) =>
    QuestionResult(
      question: json['question'] as String,
      answers:
          (json['answers'] as List<dynamic>?)?.map((e) => e as String).toList(),
    )..children = (json['children'] as List<dynamic>)
        .map((e) => QuestionResult.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$QuestionResultToJson(QuestionResult instance) =>
    <String, dynamic>{
      'question': instance.question,
      'children': instance.children.map((e) => e.toJson()).toList(),
      'answers': instance.answers,
    };
