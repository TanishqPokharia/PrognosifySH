import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prognosify/data/sleep_review.dart';
import 'package:prognosify/screens/health_matrix/sleep_monitor/sleep_review_list_notifier.dart';
import 'package:prognosify/screens/health_matrix/sleep_monitor/sleeping_status_notifier.dart';
import 'package:prognosify/widgets/sleep_review_card.dart';

final isSleepingProvider = StateNotifierProvider<SleepingStatusNotifier, bool>(
    (ref) => SleepingStatusNotifier());
final sleepingReviewListProvider =
    StateNotifierProvider<SleepingReviewListNotifier, List<SleepReview>>((ref) {
  return SleepingReviewListNotifier();
});

final sleepStartTimeProvider = StateProvider<DateTime?>((ref) => null);
final sliderValueProvider = StateProvider<double>((ref) => 0.0);
final satisfactionProvider = StateProvider<String>((ref) => "Tired");

class SleepMonitorScreen extends ConsumerWidget {
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Mon', style: style);
        break;
      case 1:
        text = const Text('Tue', style: style);
        break;
      case 2:
        text = const Text('Wed', style: style);
        break;
      case 3:
        text = const Text('Thu', style: style);
        break;
      case 4:
        text = const Text('Fri', style: style);
        break;
      case 5:
        text = const Text('Sat', style: style);
        break;
      case 6:
        text = const Text('Sun', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 2:
        text = '2hr';
        break;
      case 4:
        text = '4hr';
        break;
      case 6:
        text = '6hr';
        break;
      case 8:
        text = '8hr';
        break;
      case 10:
        text = '10hr';
        break;
      case 12:
        text = '12hr';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  String sleepStartTime = "";
  String sleepEndTime = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepingReviewList = ref.watch(sleepingReviewListProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text("Sleep Monitor"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: mq(context, 100),
                ),
                Container(
                  margin: EdgeInsets.all(mq(context, 30)),
                  height: mq(context, 300),
                  child: LineChart(LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: bottomTitleWidgets)),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 42,
                          getTitlesWidget: leftTitleWidgets,
                        ))),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.cyanAccent),
                    ),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 12,
                    lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                  "${spot.y.toString()} hrs",
                                  const TextStyle(
                                      color: Colors.cyanAccent,
                                      fontWeight: FontWeight.bold));
                            }).toList();
                          },
                        )),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          ...sleepingReviewList.map((e) => FlSpot(
                                e.dayIndex.toDouble() - 1,
                                e.timeSlept.inHours.toDouble() +
                                    e.timeSlept.inMinutes.remainder(60) / 100,
                              ))
                        ],
                        isCurved: true,
                        gradient: const LinearGradient(
                          colors: [Colors.cyanAccent, Colors.teal],
                        ),
                        barWidth: 5,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.cyanAccent.withOpacity(0.5),
                              Colors.teal.withOpacity(0.5)
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(mq(context, 20)),
                  child: ElevatedButton(
                      onPressed: () {
                        final isSleeping =
                            ref.watch(isSleepingProvider.notifier);
                        isSleeping.updateSleepingStatus(
                            ref, context, DateTime.now(), "Monday");
                      },
                      child: Text(
                        ref.watch(isSleepingProvider)
                            ? "Stop Sleep"
                            : "Start Sleep",
                        style: const TextStyle(fontSize: 18),
                      )),
                ),
                if (sleepingReviewList.isEmpty)
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: mq(context, 100)),
                      child: const MarkdownBody(
                          data:
                              "Press **Start Sleep** before sleeping to record your sleep"))
                else
                  ...sleepingReviewList
                      .map((e) => SleepReviewCard(sleepReview: e)),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ));
  }
}
