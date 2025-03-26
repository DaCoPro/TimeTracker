import 'package:flutter/material.dart';
// import 'NavBar.dart';
// import 'pages/HomePage.dart';
import 'pages/StopwatchPage.dart';
import 'pages/TimerPage.dart';
import 'pages/RecordPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/stopwatch',
      routes: {
        // '/': (context) => HomePage(),
        '/stopwatch': (context) => StopwatchPage(),
        '/timer': (context) => TimerPage(),
        '/record': (context) => RecordPage(),
      },
    );
  }
}
