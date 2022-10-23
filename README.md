# Flutter Survey
[![Pub Version](https://img.shields.io/pub/v/conditional_questions.svg?style=flat-square)](https://pub.dev/packages/conditional_questions)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
[![Codemagic build status](https://api.codemagic.io/apps/60a577211b2a304fc2cd4562/60a577211b2a304fc2cd4561/status_badge.svg)](https://codemagic.io/apps/60a577211b2a304fc2cd4562/60a577211b2a304fc2cd4561/latest_build)
[![Coverage Status](https://coveralls.io/repos/github/Michelphoenix98/conditional_questions/badge.svg?branch=master)](https://coveralls.io/github/Michelphoenix98/conditional_questions?branch=master)

A simple yet powerful package that handles the creation of a dynamic questionnaire/research survey with conditional questions.
Have you ever wanted to implement a form/questionnaire/survey like the ones you see on Google forms?
Have you ever wanted to implement conditional questions that show or hide the questions that follow, based on the user's input?
This package helps you build data collection forms hassle-free.



<img src="https://user-images.githubusercontent.com/40787439/117844127-0f39fc00-b29d-11eb-9bb3-714ba2b58811.gif" alt="Screenrecorder-2021-05-11-20-23-21-153" width="200"/>


## Installation

This project requires the latest version of [Dart](https://www.dartlang.org/). You can download the latest and greatest [here](https://www.dartlang.org/tools/sdk#install).

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
    flutter_survey: '^0.0.1'
```


#### 2. Install it

You can install packages from the command line:

```bash
$ pub get
..
```

Alternatively, your editor might support pub. Check the docs for your editor to learn more.

#### 3. Import it

Now in your Dart code, you can use:

```Dart
import 'package:flutter_survey/survey.dart';
```

## Usage

First, you must initialize the question structure where you specify the type of questions
and their possible answers, if any. You can also nest questions to form conditional questions.
You can even mark them as mandatory.

There are three types of questions.
### Questions
This is an instance of a regular question
where the answer is not limited to any specific choice.
The answer to this question can be typed in by the user, single line or multiline.
 ```Dart
 Question(
  question: "What is your name?",
)
 ```

### A full question structure represented as a List:
```Dart
 List<Question> _initialData = [
  Question(
    isMandatory: true,
    question: 'Do you like drinking coffee?',
    answerChoices: {
      "Yes": [
        Question(
            singleChoice: false,
            question: "What are the brands that you've tried?",
            answerChoices: {
              "Nestle": null,
              "Starbucks": null,
              "Coffee Day": [
                Question(
                  question: "Did you enjoy visiting Coffee Day?",
                  isMandatory: true,
                  answerChoices: {
                    "Yes": [
                      Question(
                        question: "Please tell us why you like it",
                      )
                    ],
                    "No": [
                      Question(
                        question: "Please tell us what went wrong",
                      )
                    ],
                  },
                )
              ],
            })
      ],
      "No": [
        Question(
          question: "Do you like drinking Tea then?",
          answerChoices: {
            "Yes": [
              Question(
                  question: "What are the brands that you've tried?",
                  answerChoices: {
                    "Nestle": null,
                    "ChaiBucks": null,
                    "Indian Premium Tea": [
                      Question(
                        question: "Did you enjoy visiting IPT?",
                        answerChoices: {
                          "Yes": [
                            Question(
                              question: "Please tell us why you like it",
                            )
                          ],
                          "No": [
                            Question(
                              question: "Please tell us what went wrong",
                            )
                          ],
                        },
                      )
                    ],
                  })
            ],
            "No": null,
          },
        )
      ],
    },
  ),
  Question(
      question: "What age group do you fall in?",
      isMandatory: true,
      answerChoices: const {
        "18-20": null,
        "20-30": null,
        "Greater than 30": null,
      })
];
```
### Pass the list of questions to the ConditionalQuestions Widget.
This is the main widget that handles the form.
```Dart
ConditionalQuestions(
        key: _key,
        children: questions(),
        trailing: [
          MaterialButton(
            color: Colors.deepOrange,
            splashColor: Colors.orangeAccent,
            onPressed: () async {
              if (_key.currentState!.validate()) {
                print("validated!");
              }
            },
            child: Text("Submit"),
          )
        ],
        leading: [Text("TITLE")],
      ),
```

## Full code:
```Dart
import 'package:conditional_questions/survey.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _key = GlobalKey<QuestionFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: ConditionalQuestions(
        key: _key,
        children: questions(),
        trailing: [
          MaterialButton(
            color: Colors.deepOrange,
            splashColor: Colors.orangeAccent,
            onPressed: () async {
              if (_key.currentState!.validate()) {
                print("validated!");
              }
            },
            child: Text("Submit"),
          )
        ],
        leading: [Text("TITLE")],
      ),
    );
  }
}
List<Question> questions() {
  return [
    Question(
      question: "What is your name?",
      //isMandatory: true,
      validate: (field) {
        if (field.isEmpty) return "Field cannot be empty";
        return null;
      },
    ),
    PolarQuestion(
        question: "Have you made any donations in the past?",
        answers: ["Yes", "No"],
        isMandatory: true),
    PolarQuestion(
        question: "In the last 3 months have you had a vaccination?",
        answers: ["Yes", "No"]),
    PolarQuestion(
        question: "Have you ever taken medication for HIV?",
        answers: ["Yes", "No"]),
    NestedQuestion(
      question: "The series will depend on your answer",
      answers: ["Yes", "No"],
      children: {
        'Yes': [
          PolarQuestion(
              question: "Have you ever taken medication for H1n1?",
              answers: ["Yes", "No"]),
          PolarQuestion(
              question: "Have you ever taken medication for Rabies?",
              answers: ["Yes", "No"]),
          Question(
            question: "Comments",
          ),
        ],
        'No': [
          NestedQuestion(
              question: "Have you sustained any injuries?",
              answers: [
                "Yes",
                "No"
              ],
              children: {
                'Yes': [
                  PolarQuestion(
                      question: "Did it result in a disability?",
                      answers: ["Yes", "No", "I prefer not to say"]),
                ],
                'No': [
                  PolarQuestion(
                      question: "Have you ever been infected with chicken pox?",
                      answers: ["Yes", "No"]),
                ]
              }),
        ],
      },
    )
  ];
}
```

## About me

Visit my LinkedIn at https://www.linkedin.com/in/michel98