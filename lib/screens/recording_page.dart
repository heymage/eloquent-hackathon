import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  FlutterSound flutterSound = FlutterSound();

  @override
  void dispose() {
    flutterSound.stopRecorder();
    super.dispose();
  }

  int _audioLength = 0;
  int _hour = 0;
  int _min = 0;
  int _sec = 0;
  bool _isRecording = false;
  var _micIcon = Icons.mic_none;

  Future<void> _startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    File outputFile = File('${tempDir.path}/flutter_sound-tmp.aac');
    String path = await flutterSound.startRecorder(uri: outputFile.path, codec: t_CODEC.CODEC_AAC);
    print(path);
  }

  Future<void> _endRecording() async {
    String result = await flutterSound.stopRecorder();
    print(result);
  }

  void _handleRecording() {
    if (_isRecording) {
      _isRecording = false;
      setState(() {
        _micIcon = Icons.mic_none;  
      });
      _endRecording();
    } else {
      _isRecording = true;
      setState(() {
        _micIcon = Icons.mic;  
      });
      _startRecording();
    }

    new Timer.periodic(Duration(seconds: 1), (timer) {
      setState((){
          if (_isRecording == false) {
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

  Future<void> _playRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    File fin = File('${tempDir.path}/flutter_sound-tmp.aac');
    String result = await flutterSound.startPlayer(fin.path);
    print(result);
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
                IconButton(icon: Icon(_micIcon, color: Color(0xFF020243)), iconSize: 50, onPressed: _handleRecording),
                SizedBox(width: 50),
                IconButton(icon: Icon(Icons.play_arrow, color: Color(0xFF020243)),iconSize: 50, onPressed: _playRecording),
                SizedBox(width: 50),
                IconButton(icon: Icon(Icons.delete, color: Color(0xFF020243)),iconSize: 50, onPressed: _reset)
              ],
            ),
            SizedBox(height: 200),
            IconButton(icon: Icon(Icons.graphic_eq, color: Color(0xFF020243)), iconSize: 60, onPressed: null),
            SizedBox(height: 25),
          ],
        )
      )
    );
  }
}
