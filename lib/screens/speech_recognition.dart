import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';


class SpeechRecognitionPage extends StatefulWidget {
  @override
  _SpeechRecognitionPageState createState() => _SpeechRecognitionPageState();
}

class _SpeechRecognitionPageState extends State<SpeechRecognitionPage> {
  SpeechRecognition _speechRecognition;

  // states for handling record availability and if its listening
  bool _isAvailable = false;
  bool _isListening = false;

  // Result string after parsing speech to text
  String _speechText = "";

  // variables for showing timecode
  int _hour = 0;
  int _min = 0;
  int _sec = 0;

  // for interchange Icons regarded to the app is recording or not
  var _micIcon = Icons.mic_none;

  // variable fo calculating wps
  int _audioLength = 0;
  double _wps;
  String _displayText = "";

  @override
  void initState() {
    super.initState();
    _initSpeechRecognizer();
  }

  void _initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler((bool result) {
      setState(() {
        _isAvailable = result;
      });
    });
    _speechRecognition.setRecognitionStartedHandler(() {
      setState(() {
        _isListening = true;
        _handleTimer();
      });
    });
    _speechRecognition.setRecognitionResultHandler((String speech) {
      setState(() {
        _speechText = speech;
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

  void _handleTimer() {
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

  void _startRecording() {
    if (_isAvailable && !_isListening) {
      _speechRecognition
        .listen(locale: 'en_US')
        .then((result) => print('$result'));
    }
    _resetTimer();
    _displayText = "";
  }

  void _stopRecording() {
    if (_isListening) {
      _speechRecognition.stop().then((result) {
        setState(() {
          _isListening = result;
      });
    });
    }
  }

  // handle recording based on the state
  void _handleRecording() {
    if (_isListening) {
      setState(() {
        _micIcon = Icons.mic_none;  
      });
      _stopRecording();
    } else {
      setState(() {
        _micIcon = Icons.mic;  
      });
      _startRecording();
    }
  }

  void _calculateWps() {
    setState(() {
      _wps = (_speechText.split(" ").length+1) / _audioLength;  
    });

    _displayText = "You spoke ${_wps.toString().length > 5 ? _wps.toString().substring(0, 4) : _wps.toString()} words per second!";
  }

  void _resetTimer() {
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
            SizedBox(height: 25),
            Text("Words per second recognizer", style: TextStyle(color: Color(0xFF020243), fontSize: 20)),
            SizedBox(height: 50),
            Text("${_hour.toString()}:${_min.toString()}:${_sec.toString()}", style: TextStyle(color: Color(0xFF020243), fontSize: 20)),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(icon: Icon(_micIcon, color: Color(0xFF020243)), iconSize: 50, onPressed: _handleRecording),
                SizedBox(width: 50),
                IconButton(icon: Icon(Icons.delete, color: Color(0xFF020243)),iconSize: 50, onPressed: _resetTimer),
              ],
            ),
            SizedBox(height: 125),
            IconButton(icon: Icon(Icons.graphic_eq), onPressed: _calculateWps, iconSize: 75),
            SizedBox(height: 25),
            Text(_displayText, style: TextStyle(color: Color(0xFF020243), fontSize: 20))
          ],
        )
      )
    );
  }
}
