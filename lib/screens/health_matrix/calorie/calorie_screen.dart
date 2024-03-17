import 'package:flutter/material.dart';
import 'package:prognosify/data/calorie_data.dart';
import 'package:prognosify/widgets/calorie_history_card.dart';

class CaloriesScreen extends StatelessWidget {
  const CaloriesScreen({super.key});
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
                margin: EdgeInsets.all(20),
                child: Text(
                  "Steps since device reboot: 80000",
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
                        padding: EdgeInsets.all(30),
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
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "113",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "kcal",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                )
                              ],
                            )
                          ],
                        )),
                    Container(
                        decoration: ShapeDecoration(
                            shape: CircleBorder(side: BorderSide(width: 2))),
                        padding: EdgeInsets.all(30),
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions_walk,
                              size: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "3113",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "steps",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
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
                        padding: EdgeInsets.all(30),
                        child: Row(
                          children: [
                            Icon(
                              Icons.place,
                              size: 40,
                              color: Colors.teal,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "2.26",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "km",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
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
                margin: EdgeInsets.all(30),
                child: Text(
                  "Past Week History",
                  style: TextStyle(fontSize: 28),
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
