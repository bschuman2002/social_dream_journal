import "package:flutter/material.dart";
import "package:social_dream_journal/views/journal_entry_view.dart";
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
          ..sort((a, b) => a.date.compareTo(b.date));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
                padding: EdgeInsets.only(top: 100, left: 16),
                child: Text('Sleep Score Trends',
                    style: TextStyle(color: Colors.white, fontSize: 30))),
            const SizedBox(height: 100),
            SizedBox(
                height: 500, child: TrendLineChart(userEntries: userEntries)),
          ])),
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
        padding: const EdgeInsets.only(top: 0, right: 30, bottom: 16, left: 16),
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.purple.shade100,
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: 1,
              )),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 86400000 >
                        (data.isEmpty
                                ? 0
                                : data.last.x.millisecondsSinceEpoch
                                        .toDouble() -
                                    (data.isEmpty
                                            ? 0
                                            : data
                                                .first.x.millisecondsSinceEpoch)
                                        .toDouble()) /
                            4
                    ? 86400000
                    : (data.isEmpty
                            ? 0
                            : data.last.x.millisecondsSinceEpoch.toDouble() -
                                (data.isEmpty
                                        ? 0
                                        : data.first.x.millisecondsSinceEpoch)
                                    .toDouble()) /
                        4,
                // You can customize the format and appearance further if needed
                getTitlesWidget: (value, meta) {
                  final date =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  if (value == meta.min || value == meta.max) {
                    return Container();
                  }
                  return Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        '${date.month}/${date.day}',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ));
                },
              )),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d), width: 1),
            ),
            minX: data.isEmpty
                ? 0
                : data.first.x.millisecondsSinceEpoch.toDouble() - 86400000,
            maxX: data.isEmpty
                ? 0
                : data.last.x.millisecondsSinceEpoch.toDouble() + 86400000,
            minY: 0,
            maxY: 10,
            lineBarsData: [
              LineChartBarData(
                color: Colors.blue.shade900,
                spots: data
                    .map((point) => FlSpot(
                          point.x.millisecondsSinceEpoch.toDouble(),
                          point.y.toDouble(),
                        ))
                    .toList(),
                isCurved: false,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) =>
                      touchedSpots.map((spot) => null).toList()),
              touchCallback: (event, touchResponse) {
                if (event is FlTapUpEvent) {
                  if (touchResponse?.lineBarSpots != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => journal_entry_view(
                                entry: userEntries[touchResponse!
                                    .lineBarSpots!.first.spotIndex])));
                  }
                }
              },
            ),
          ),
        ));
  }
}

class Point {
  final DateTime x;
  final double y;

  Point(this.x, this.y);
}
