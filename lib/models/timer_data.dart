import 'dart:convert';

class TimerData {
  final DateTime startTime;
  final DateTime endTime;
  final String focus;

  TimerData({required this.startTime, required this.endTime, required this.focus});

  Map<String, dynamic> toJson() => {
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'focus': focus
  };
}