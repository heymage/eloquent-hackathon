import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class RecPage extends StatefulWidget {
  @override
  _RecPageState createState() => _RecPageState();
}

class _RecPageState extends State<RecPage> {

  FlutterAudioRecorder _recorder;
  Recording _recording;
  int _hour = 0;
  int _min = 0;
  int _sec = 0;
  bool _isRecording = false;
  String _customPath = '/eloquent_hackathon';

  Future<void> _recordSpeech() async {
    bool hasPermission = await FlutterAudioRecorder.hasPermissions;

    if (hasPermission) {
    Directory appDocDirectory;
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        _customPath = appDocDirectory.path +
          _customPath +
          DateTime.now().millisecondsSinceEpoch.toString();
        print("customPath: $_customPath");
      if (_isRecording) {
        _isRecording = false;
        
        var result = await _recorder.stop();
        setState(() {
          _recording = result;
        });
        AudioPlayer player = AudioPlayer();
        File file = new File(_recording.path);
        player.play(file.path, isLocal: true);
      
      } else {
        _isRecording = true;
        _recorder = FlutterAudioRecorder(_customPath, audioFormat: AudioFormat.AAC);
        await _recorder.initialized;
        await _recorder.start();
        _recording = await _recorder.current(channel: 0);
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