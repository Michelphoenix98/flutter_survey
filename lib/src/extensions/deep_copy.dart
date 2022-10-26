import 'package:flutter_survey/flutter_survey.dart';

extension DeepCopy on Question {
  Question clone() {
    return Question.fromJson(toJson());
  }
}
