import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/timer_data.dart';

class TimerService {
  static Future<void> saveTimerData(TimerData timerData) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/timers.json');

    List<dynamic> timers = [];
    if (await file.exists()) {
      final content = await file.readAsString();
      timers = jsonDecode(content);
    }

    timers.add(timerData.toJson());
    await file.writeAsString(jsonEncode(timers));
  }
}