import 'package:flutter/material.dart';
import 'package:eloquent_hackathon/screens/basic_recorder.dart';
import 'package:eloquent_hackathon/screens/speech_recognition.dart';

void main() => runApp(App());

class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabPages = <Widget>[
      BasicRecorderPage(),
      SpeechRecognitionPage()
    ];
  
    final navBarItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            activeIcon: Icon(Icons.mic_none, color: Color(0xFF020243), size: 35.0),
            icon: Icon(Icons.mic_none, color: Color(0xFF3c3c3c), size: 35.0),
            title: Text('Audio Recorder')),
        BottomNavigationBarItem(
            activeIcon: Icon(Icons.spellcheck,color: Color(0xFF020243), size: 35.0),
            icon: Icon(Icons.spellcheck, color: Color(0xFF3c3c3c), size: 35.0),
            title: Text('WPS Recognition')),
    ];

    assert(tabPages.length == navBarItems.length);
    final bottomNavBar = BottomNavigationBar(
      items: navBarItems,
      currentIndex: currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          currentTabIndex = index;
        });
      },
      backgroundColor: Color(0x88ECECEC),
      selectedItemColor: Color(0xFF020243),
      elevation: 0.0,
    );

  // This widget is the root of your application.

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Image(image: AssetImage('assets/Eloquent.png')),
          title: Text('Eloquent', style: TextStyle(fontFamily: 'QS-M', color: Color(0xFF3C3C3C))),
          backgroundColor: Color(0x88ECECEC),
          elevation: 0.0,
        ),
        body: tabPages[currentTabIndex],
        bottomNavigationBar: bottomNavBar,
      ),
      debugShowCheckedModeBanner: false,
    );


  }
}
