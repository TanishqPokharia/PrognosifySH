import 'package:flutter/material.dart';
import 'package:prognosify/data/calorie_data.dart';

class CalorieHistoryCard extends StatelessWidget {
  final CalorieData calorieData;

  const CalorieHistoryCard({super.key, required this.calorieData});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 150,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  calorieData.day,
                  style: TextStyle(fontSize: 20),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "${calorieData.calories} kcal",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Burned Calories",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      calorieData.steps,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Steps",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      calorieData.distance,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Distance",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
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
