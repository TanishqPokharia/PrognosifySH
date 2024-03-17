import 'package:flutter/material.dart';
import 'package:prognosify/data/calorie_data.dart';
import 'package:prognosify/models/mediaquery/mq.dart';

class CalorieHistoryCard extends StatelessWidget {
  final CalorieData calorieData;

  const CalorieHistoryCard({super.key, required this.calorieData});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: mq(context, 150),
      margin: EdgeInsets.symmetric(
          horizontal: mq(context, 20), vertical: mq(context, 10)),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.all(mq(context, 20)),
                child: Text(
                  calorieData.day,
                  style: TextStyle(fontSize: mq(context, 20)),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "${calorieData.calories} kcal",
                      style: TextStyle(fontSize: mq(context, 18)),
                    ),
                    Text(
                      "Burned Calories",
                      style: TextStyle(
                          color: Colors.grey, fontSize: mq(context, 16)),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      calorieData.steps,
                      style: TextStyle(fontSize: mq(context, 18)),
                    ),
                    Text(
                      "Steps",
                      style: TextStyle(
                          color: Colors.grey, fontSize: mq(context, 16)),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      calorieData.distance,
                      style: TextStyle(fontSize: mq(context, 18)),
                    ),
                    Text(
                      "Distance",
                      style: TextStyle(
                          color: Colors.grey, fontSize: mq(context, 16)),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
