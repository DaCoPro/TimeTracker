import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomo_timer_flutter/NavBar.dart';
import '../models/timer_data.dart';
import '../services/timer_service.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  String _displayTime = '00:00:00';
  bool _isRunning = false;
  bool _hasStarted = false;
  bool _isSaved = false;

  void _startStopwatch() {
    if (!_isSaved) {
      _stopwatch.start();
      _isRunning = true;
      _hasStarted = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _displayTime = _formatTime(_stopwatch.elapsed);
        });
      });
    }
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _isRunning = false;
    _timer.cancel();
    setState(() {});
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {
      _displayTime = '00:00:00';
      _isRunning = false;
      _hasStarted = false;
      _isSaved = false;
    });
  }

  Future<void> _saveStopwatchData() async {
    final startTime = DateTime.now().subtract(_stopwatch.elapsed);
    final endTime = DateTime.now();
    final timerData = TimerData(startTime: startTime, endTime: endTime);
    await TimerService.saveTimerData(timerData);
    setState(() {
      _isSaved = true; // Disable the save button after saving
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stopwatch')),
      drawer: NavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_displayTime, style: TextStyle(fontSize: 48)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning || _isSaved ? null : _startStopwatch,
                  child: Text('Start'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isRunning ? _stopStopwatch : null,
                  child: Text('Stop'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetStopwatch,
                  child: Text('Reset'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: !_hasStarted || _isRunning || _isSaved ? null : _saveStopwatchData,
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}