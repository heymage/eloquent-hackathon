import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
class SpeechRecPage extends StatefulWidget {
  @override
  _SpeechRecPageState createState() => _SpeechRecPageState();
}
class _SpeechRecPageState extends State<SpeechRecPage> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  String resultText = '';
  int _audioLength = 0;
  int _hour = 0;
  int _min = 0;
  int _sec = 0;
  double wps;
  String displayText = "";

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }
  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler((bool result) {
      setState(() {
        _isAvailable = result;
      });
    });
    _speechRecognition.setRecognitionStartedHandler(() {
      setState(() {
        _isListening = true;
        timing();
      });
    });
    _speechRecognition.setRecognitionResultHandler((String speech) {
      setState(() {
        resultText = speech;
      });
    });
    _speechRecognition.setRecognitionCompleteHandler(() {
      setState(() {
        _isListening = false;
      });
    });
    _speechRecognition.activate().then((result) {
      setState(() {
        _isAvailable = result;
      });
    });
  }

  void timing() {
    new Timer.periodic(Duration(seconds: 1), (timer) {
      setState((){
          if (_isListening == false) {
            timer.cancel();
            return;
          }
          _audioLength += 1;
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

  void rec() {
    if (_isAvailable && !_isListening) {
      _speechRecognition
        .listen(locale: 'en_US')
        .then((result) => print('$result'));
    }
    _reset();
    displayText = "";
  }

  void stop() {
    if (_isListening) {
      _speechRecognition.stop().then((result) {
        setState(() {
          _isListening = result;
      });
    });
    }
  }

  void calc() {
    int wordCount = resultText.split(" ").length;
    print("${wordCount.toString()} : ${_audioLength.toString()}");
    print("WPS: ${(wordCount+1)/_audioLength}");
    setState(() {
      wps = (wordCount+1)/_audioLength;  
    });

    displayText = "You spoke ${wps.toString().length > 5 ? wps.toString().substring(0, 4) : wps.toString()} word per second!";
    
  }

  void _reset() {
    _audioLength = 0;
    setState(() {
      _hour = 0;
    _min = 0;
    _sec = 0;  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
            child: Column(
          children: <Widget>[
            SizedBox(height: 75),
            Text("Start Recording", style: TextStyle(color: Color(0xFF020243), fontSize: 30)),
            SizedBox(height: 50),
            Text("${_hour.toString()}:${_min.toString()}:${_sec.toString()}", style: TextStyle(color: Color(0xFF020243), fontSize: 20)),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(icon: Icon(Icons.mic, color: Color(0xFF020243)), iconSize: 50, onPressed: rec),
                SizedBox(width: 50),
                IconButton(icon: Icon(Icons.stop, color: Color(0xFF020243)),iconSize: 50, onPressed: stop),
                SizedBox(width: 50),
                IconButton(icon: Icon(Icons.delete, color: Color(0xFF020243)),iconSize: 50, onPressed: _reset),
              ],
            ),
            SizedBox(height: 180),
            //IconButton(icon: Icon(Icons.graphic_eq, color: Color(0xFF020243)), iconSize: 60, onPressed: calc),
            GestureDetector(
              child: Image(image: AssetImage("Eloquent.png"), width: 60, height: 60),
              onTap: calc,
            ),
            SizedBox(height: 55),
            Text(displayText, style: TextStyle(color: Color(0xFF020243), fontSize: 20))
          ],
        )
      )
    );
  }
}
