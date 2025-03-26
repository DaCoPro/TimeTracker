import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../NavBar.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  List<BarChartGroupData> _barChartData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/timers.json');

    if (await file.exists()) {
      final content = await file.readAsString();
      final timers = jsonDecode(content);

      Map<String, double> workTimePerDay = {};

      for (var timer in timers) {
        DateTime startTime = DateTime.parse(timer['startTime']);
        DateTime endTime = DateTime.parse(timer['endTime']);
        double workTime = endTime.difference(startTime).inMinutes.toDouble() / 60.0;

        String dateStr = startTime.toIso8601String().split('T')[0];
        if (workTimePerDay.containsKey(dateStr)) {
          workTimePerDay[dateStr] = (workTimePerDay[dateStr] ?? 0) + workTime;
        } else {
          workTimePerDay[dateStr] = workTime;
        }
      }

      // Add missing dates with zero hours
      if (workTimePerDay.isNotEmpty) {
        DateTime firstDate = DateTime.parse(workTimePerDay.keys.first);
        DateTime lastDate = DateTime.parse(workTimePerDay.keys.last);

        for (DateTime date = firstDate;
            date.isBefore(lastDate.add(Duration(days: 1)));
            date = date.add(Duration(days: 1))) {
          String dateStr = date.toIso8601String().split('T')[0];
          if (!workTimePerDay.containsKey(dateStr)) {
            workTimePerDay[dateStr] = 0;
          }
        }
      }

      // Sort the map by date
      var sortedEntries = workTimePerDay.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      List<BarChartGroupData> data = sortedEntries
          .map((entry) => BarChartGroupData(
                x: int.parse(entry.key.split('-')[2]), // Assuming date format is YYYY-MM-DD
                barRods: [BarChartRodData(toY: entry.value)],
              ))
          .toList();

      setState(() {
        _barChartData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxY = _barChartData.isNotEmpty
        ? _barChartData.map((group) => group.barRods[0].toY).reduce((a, b) => a > b ? a : b) + 1
        : 1;

    return Scaffold(
      appBar: AppBar(title: Text('Record Page')),
      drawer: NavBar(),
      body: Center(
        child: _barChartData.isEmpty
            ? CircularProgressIndicator()
            : BarChart(
                BarChartData(
                  barGroups: _barChartData,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}h');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}');
                        },
                      ),
                    ),
                  ),
                  maxY: maxY,
                ),
                swapAnimationDuration: Duration(seconds: 1),
                swapAnimationCurve: Curves.easeInOut,
              ),
      ),
    );
  }
}

class WorkTime {
  final String date;
  final double hours;

  WorkTime(this.date, this.hours);

}