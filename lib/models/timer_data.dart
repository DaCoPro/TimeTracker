import 'dart:convert';

class TimerData {
  final DateTime startTime;
  final DateTime endTime;

  TimerData({required this.startTime, required this.endTime});

  Map<String, dynamic> toJson() => {
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
  };
}