import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Time Tracker')),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Stopwatch'),
            onTap: () {
              Navigator.pushNamed(context, '/stopwatch');
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Timer'),
            onTap: () {
              Navigator.pushNamed(context, '/timer');
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Record'),
            onTap: () {
              Navigator.pushNamed(context, '/record');
            },
          ),
        ],
      ),
    );
  }
}