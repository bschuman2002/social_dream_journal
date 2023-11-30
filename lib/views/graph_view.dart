import "package:flutter/material.dart";
import "package:social_dream_journal/widgets/navbar.dart";
import "package:fl_chart/fl_chart.dart";
import "package:social_dream_journal/viewmodels/journal_entry_list_view_model.dart";
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';
import 'package:provider/provider.dart';

class GraphView extends StatelessWidget {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    List<JournalEntryViewModel> userEntries =
        Provider.of<JournalListProvider>(context).userJournalViewModels.toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    return Scaffold(
      body: TrendLineChart(userEntries: userEntries),
      bottomNavigationBar: const NavBar(
        pageIndex: 2,
      ),
    );
  }
}

class TrendLineChart extends StatelessWidget {
  const TrendLineChart({super.key, required this.userEntries});
  final List<JournalEntryViewModel> userEntries;

  @override
  Widget build(BuildContext context) {
    final List<Point> data = userEntries
        .map((entry) => Point(entry.date, entry.sleepScore.toDouble()))
        .toList();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25,
              interval: 1,
            )),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 86400000,
              // You can customize the format and appearance further if needed
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                // if (value == meta.max) {
                //   return Container();
                // }
                return Text(
                  '${date.month}/${date.day}',
                  style: TextStyle(
                    color: Color(0xff68737d),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                );
              },
            )),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minX: data.first.x.millisecondsSinceEpoch.toDouble(),
          maxX: data.last.x.millisecondsSinceEpoch.toDouble(),
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .map((point) => FlSpot(
                        point.x.millisecondsSinceEpoch.toDouble(),
                        point.y.toDouble(),
                      ))
                  .toList(),
              isCurved: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

class Point {
  final DateTime x;
  final double y;

  Point(this.x, this.y);
}
