import 'package:flutter_survey/flutter_survey.dart';

extension DeepCopy on Question {
  ///Returns a clone of the question and not the reference.
  Question clone() {
    return Question.fromJson(toJson());
  }
}
