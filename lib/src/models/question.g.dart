// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      question: json['question'] as String,
      singleChoice: json['single_choice'] as bool? ?? true,
      answerChoices: (json['answer_choices'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>?)
                ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      isMandatory: json['is_mandatory'] as bool? ?? false,
      errorText: json['error_text'] as String?,
      properties: json['properties'] as Map<String, dynamic>?,
      answers:
          (json['answers'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'question': instance.question,
      'single_choice': instance.singleChoice,
      'answer_choices': instance.answerChoices
          .map((k, e) => MapEntry(k, e?.map((e) => e.toJson()).toList())),
      'is_mandatory': instance.isMandatory,
      'error_text': instance.errorText,
      'properties': instance.properties,
      'answers': instance.answers,
    };
