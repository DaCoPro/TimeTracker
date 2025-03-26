import 'dart:async';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../models/timer_data.dart';
import '../services/timer_service.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Timer _timer;
  int _remainingTime = 3000; // 50 minutes in seconds
  bool _isWorkMode = true;
  bool _isSaved = false;
  bool _isRunning = false;
  bool _hasStarted = false;
  DateTime? _startTime;
  final TextEditingController _focusController = TextEditingController();

  void _startTimer() {
    if (!_isSaved) {
      _startTime = DateTime.now();
      _isRunning = true;
      _hasStarted = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _timer.cancel();
            _isRunning = false;
          }
        });
      });
    }
  }

  void _stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _toggleMode(bool isWork) {
    setState(() {
      _isWorkMode = isWork;
      _remainingTime = _isWorkMode ? 3000 : 600; // 50 minutes or 10 minutes in seconds
      _isSaved = false; // Reset the saved state when mode is toggled
      _isRunning = false; // Ensure the timer is not running
      _hasStarted = false; // Reset the started state when mode is toggled
      if (!_isWorkMode) {
        _focusController.clear(); // Clear the focus input field when switching to break mode
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = _isWorkMode ? 3000 : 600; // Reset to initial value
      if (_timer.isActive) {
        _timer.cancel(); // Cancel the current timer if running
      }
      _isSaved = false; // Allow the timer to be started again after reset
      _isRunning = false; // Ensure the timer is not running
      _hasStarted = false; // Reset the started state
      if (!_isWorkMode) {
        _focusController.clear(); // Clear the focus input field when resetting in break mode
      }
    });
  }

  Future<void> _saveTimerData() async {
    if (_isWorkMode) {
      final endTime = DateTime.now();
      final focus = _focusController.text;
      final timerData = TimerData(startTime: _startTime!, endTime: endTime, focus: focus);
      await TimerService.saveTimerData(timerData);
      setState(() {
        _isSaved = true; // Disable the save button after saving
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer')),
      drawer: NavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Break'),
                Switch(
                  value: _isWorkMode,
                  onChanged: _toggleMode,
                ),
                Text('Work'),
              ],
            ),
            SizedBox(height: 20),
            Text(_isWorkMode ? 'Work Timer' : 'Break Timer', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text(_formatTime(_remainingTime), style: TextStyle(fontSize: 48)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isSaved || _isRunning ? null : _startTimer,
                  child: Text('Start Timer'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isSaved || !_isRunning ? null : _stopTimer,
                  child: Text('Stop Timer'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text('Reset Timer'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: !_hasStarted || _isRunning || _isSaved || !_isWorkMode ? null : _saveTimerData,
                  child: Text('Save Timer'),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_isWorkMode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _focusController,
                  decoration: InputDecoration(
                    labelText: 'Focus',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}