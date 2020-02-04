import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class BasicRecorderPage extends StatefulWidget {
  @override
  _BasicRecorderPageState createState() => _BasicRecorderPageState();
}

class _BasicRecorderPageState extends State<BasicRecorderPage> {
  FlutterSound flutterSound = FlutterSound();

  // handling what should happen if the app gets minimized
  @override
  void dispose() {
    flutterSound.stopRecorder();
    super.dispose();
  }

  // variable for calculating wps
  // int _audioLength = 0;

  // variables for showing timecode
  int _hour = 0;
  int _min = 0;
  int _sec = 0;

  // state if app is recording or playing
  bool _isRecording = false;
  bool _isPlaying = false;

  // for interchange Icons regarded to the app is recording or playing or not
  var _micIcon = Icons.mic_none;
  var _playIcon = Icons.play_circle_outline;

  Future<void> _startRecording() async {
    _resetTimer();
    Directory tempDir = await getTemporaryDirectory();
    File outputFile = File('${tempDir.path}/flutter_sound-tmp.aac');
    await flutterSound.startRecorder(uri: outputFile.path, codec: t_CODEC.CODEC_AAC);
  }

  Future<void> _endRecording() async {
    await flutterSound.stopRecorder();
  }

  // handle recording based on the state
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
          //_audioLength += 1;
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

  Future<void> _startPlayback() async {
    Directory tempDir = await getTemporaryDirectory();
    File fin = File('${tempDir.path}/flutter_sound-tmp.aac');
    await flutterSound.startPlayer(fin.path);
  }

  Future<void> _stopPlayback() async {
    await flutterSound.stopPlayer();
  }

  // handle playback based on the state
  void _handlePlayback() {
    if (_isPlaying) {
      _isPlaying = false;
      setState(() {
        _playIcon = Icons.play_circle_outline;  
      });
      _stopPlayback();
    } else {
      _isPlaying = true;
      setState(() {
        _playIcon = Icons.pause_circle_outline;  
      });
      _startPlayback();
    }
  }

  void _resetTimer() {
    //_audioLength = 0;
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
            Text("Eloquent", style: TextStyle(color: Color(0xFF020243), fontSize: 30)),
            SizedBox(height: 50),
            Text("${_hour.toString()}:${_min.toString()}:${_sec.toString()}", style: TextStyle(color: Color(0xFF020243), fontSize: 20)),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(icon: Icon(_micIcon, color: Color(0xFF020243)), iconSize: 50, onPressed: _handleRecording),
                SizedBox(width: 50),
                IconButton(icon: Icon(_playIcon, color: Color(0xFF020243)),iconSize: 50, onPressed: _handlePlayback),
                SizedBox(width: 50),
                IconButton(icon: Icon(Icons.delete, color: Color(0xFF020243)),iconSize: 50, onPressed: _resetTimer)
              ],
            ),
            SizedBox(height: 200),
            GestureDetector(
              child: Image(image: AssetImage("assets/Eloquent.png"), width: 100, height: 100),
            ),
            SizedBox(height: 25),
          ],
        )
      )
    );
  }
}
