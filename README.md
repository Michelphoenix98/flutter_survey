# Flutter Survey


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
You can even mark them as mandatory. This can be either in json format fetched from the server or can be constructed using the
[Question] model provided as part of this package. The structure is intuitive and determines the flow of the form.

### Types of questions.
The Questions are classified based on the kind of input they take.

### Text Input Question
As the name suggests here the answer is not limited to any specific choice.
The answer to this question can be typed in by the user, single line or multiline.
Setting the [answerChoice] variable to null or simply leaving it altogether gives you this.    
 ```Dart
 Question(
  question: "What is your name?",
)
 ```
### Single Choice Question
Here, Radio Buttons are used as input. You define the possible answer choices as a Map,
with the keys being the answer choices. Note that the value of the corresponding keys happen to be null.
This is because they don't have an associated list of questions that follow it.

 ```Dart
  Question(
    question: 'Do you like drinking coffee?',
    answerChoices: {
      "Yes": null,
      "No": null,
    },
  ),
 ```

### Multiple Choice Question
Here, Checkboxes are used as input. Just like the Single Choice Questions, You define the possible answer choices as a Map
with the keys being the answer choices. Note that even here the value of the corresponding keys happen to be null for the same
reason as Single Choice Questions. The difference here is that you set [isSingleChoice] to false.

 ```Dart
  Question(
    isSingleChoice: false,
    question: 'What are the brands that you've tried?',
    answerChoices: {
      "Nestle": null,
      "Starbucks": null,
      "Coffee Day": null,
    },
  ),
 ```
### Conditional/Nested Questions
This is where you define questions that follow based on the answer of the question prior to it.
The values of the keys defined in the [answerChoices] field determines the flow. For example here, 
if the user were to choose "Yes" to "Do you like drinking coffee", the user would be confronted with 
another question "What are the brands you've tried?" followed by more nesting.

 ```Dart

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
         Survey(
          initialData: _surveyData,
        )
```

## Full code:
```Dart
import 'package:flutter/material.dart';
import 'package:flutter_survey/flutter_survey.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      title: 'Flutter Demo',
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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Form(
        key: _formKey,
        child: Survey(
          initialData: [
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
                                        question:
                                        "Please tell us why you like it",
                                      )
                                    ],
                                    "No": [
                                      Question(
                                        question:
                                        "Please tell us what went wrong",
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
          ],
        ),
      ),
      bottomNavigationBar: TextButton(
        child: Text("Validate"),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            //do something
          }
        },
      ),
    );
  }
}
```

## About me

Visit my LinkedIn at https://www.linkedin.com/in/michel98