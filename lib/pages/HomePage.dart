import 'package:flutter/material.dart';
import '../NavBar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer App')),
      drawer: NavBar(),
      body: Center(child: Text('Timer App')),
    );
  }
}