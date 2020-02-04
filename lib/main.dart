import 'package:flutter/material.dart';
import 'package:eloquent_hackathon/screens/rec_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
