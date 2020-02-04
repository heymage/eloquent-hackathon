import 'dart:async';
import 'package:flutter/material.dart';

class RecPage extends StatefulWidget {
  @override
  _RecPageState createState() => _RecPageState();
}

class _RecPageState extends State<RecPage> {

  int _hour = 0;
  int _min = 0;
  int _sec = 0;
  bool _isRecording = false;

  void _recordSpeech(){
    if (_isRecording) {
      _isRecording = false;  
    } else {
      _isRecording = true;
    }
  
    new Timer.periodic(new Duration(milliseconds: 1000), (timer) {
      setState((){
        if (_isRecording == false){
          timer.cancel();
          return;
        }
        _sec += 1;
        if (_sec > 59) {
          _sec = 0;
          _min += 1;
          if (_min > 59 && _sec > 59) {
            _sec = 0;
            _min = 0;
            _hour += 1;
          }
        }
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
            Text("${_hour.toString()}:${_min.toString()}:${_sec.toString()}"),
            SizedBox(height: 10),
            IconButton(icon: Icon(Icons.mic_none), onPressed: _recordSpeech),
          ],
        )
      )
      );
  }
}