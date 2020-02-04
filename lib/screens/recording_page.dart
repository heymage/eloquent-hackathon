import 'package:flutter/material.dart';

class RecordingPage extends StatelessWidget {

  void recordSpeech() {
    print("Recording...");
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
            Text("00:00:00"),
            SizedBox(height: 10),
            IconButton(icon: Icon(Icons.mic_none), onPressed: recordSpeech)

          ],
        )
      )
      );
  }
}
