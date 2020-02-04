import 'package:flutter/material.dart';
import 'package:eloquent_hackathon/screens/basic_recorder.dart';
import 'package:eloquent_hackathon/screens/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: BasicRecorderPage(),
      home: SpeechRecognitionPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
