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
            Text("00:00:00"),
            SizedBox(height: 10),
            IconButton(
                icon: Icon(Icons.mic_none),
                onPressed: () async {
                  Directory tempDir = await getTemporaryDirectory();
                  File outputFile =
                      File('${tempDir.path}/flutter_sound-tmp.aac');
                  String path = await flutterSound.startRecorder(
                    uri: outputFile.path,
                    codec: t_CODEC.CODEC_AAC,
                  );
                  print(path);
                }),
            IconButton(
                icon: Icon(Icons.stop),
                onPressed: () async {
                  String result = await flutterSound.stopRecorder();
                  print(result);
                }),
            IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () async {
                  Directory tempDir = await getTemporaryDirectory();
                  File fin = File('${tempDir.path}/flutter_sound-tmp.aac');
                  String result = await flutterSound.startPlayer(fin.path);
                  print(result);
                }),
            IconButton(icon: Icon(Icons.stop), onPressed: () async {}),
          ],
        )));
  }
}
