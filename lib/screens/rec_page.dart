import 'dart:async';
import 'package:flutter/material.dart';

class RecPage extends StatefulWidget {
  @override
  _RecPageState createState() => _RecPageState();
}

class _RecPageState extends State<RecPage> {

  double _value = 0.0;
  bool _isRecording = false;

  void _recordSpeech(){
    new Timer.periodic(new Duration(milliseconds: 10), (timer) {
      setState((){
        if (!_isRecording){
          timer.cancel();
          return;
        }
        _value += 0.01;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ELOQUENT'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Text("Record your speech to get feedback on it"),
            SizedBox(height: 20),
            Text(_value.toString()),
            SizedBox(height: 10),
            IconButton(icon: Icon(Icons.mic_none), onPressed: _recordSpeech)

          ],
        )
      )
      );
  }
}