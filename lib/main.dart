import 'package:eloquent_hackathon/screens/speechrec.dart';
import 'package:flutter/material.dart';
import 'package:eloquent_hackathon/screens/recording_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: RecordingPage(),
      home: SpeechRecPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
