import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:prognosify/data/calorie_data.dart';
import 'package:prognosify/models/mediaquery/mq.dart';
import 'package:prognosify/widgets/calorie_history_card.dart';

class CaloriesScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return CalorieScreenState();
  }
}

class CalorieScreenState extends ConsumerState<CaloriesScreen> {
  late Stream<StepCount> _stepCountStream;
  String _steps = "?";

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie"),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(mq(context, 20)),
                child: Text(
                  "Steps since device reboot: $_steps",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: ShapeDecoration(
                            shape: CircleBorder(
                                side: BorderSide(
                                    width: 2, color: Colors.orange))),
                        padding: EdgeInsets.all(mq(context, 30)),
                        child: Row(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                    Colors.red,
                                    Colors.orange,
                                    Colors.yellow
                                  ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight)
                                  .createShader(bounds),
                              child: Icon(
                                Icons.whatshot,
                                size: mq(context, 40),
                                color: Colors.white,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "113",
                                  style: TextStyle(
                                      fontSize: mq(context, 18),
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "kcal",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: mq(context, 14)),
                                )
                              ],
                            )
                          ],
                        )),
                    Container(
                        decoration: ShapeDecoration(
                            shape: CircleBorder(side: BorderSide(width: 2))),
                        padding: EdgeInsets.all(mq(context, 30)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions_walk,
                              size: mq(context, 40),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "3113",
                                  style: TextStyle(
                                      fontSize: mq(context, 18),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "steps",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: mq(context, 18)),
                                )
                              ],
                            )
                          ],
                        )),
                    Container(
                        decoration: ShapeDecoration(
                            shape: CircleBorder(
                                side:
                                    BorderSide(width: 2, color: Colors.teal))),
                        padding: EdgeInsets.all(mq(context, 30)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.place,
                              size: mq(context, 40),
                              color: Colors.teal,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "2.26",
                                  style: TextStyle(
                                      fontSize: mq(context, 18),
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "km",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: mq(context, 14),
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(mq(context, 30)),
                child: Text(
                  "Past Week History",
                  style: TextStyle(fontSize: mq(context, 28)),
                ),
              ),
              ...calorieDataList.map((e) => CalorieHistoryCard(calorieData: e))
            ],
          ),
        ),
      ),
    );
  }
}

List<CalorieData> calorieDataList = [
  CalorieData(
      day: "Saturday", calories: "200", steps: "3112", distance: "3.16km"),
  CalorieData(
      day: "Friday", calories: "305", steps: "5112", distance: "4.17km"),
  CalorieData(
      day: "Thursday", calories: "212", steps: "3443", distance: "3.32km"),
  CalorieData(
      day: "Wednesday", calories: "262", steps: "3443", distance: "3.67km")
];
