import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prognosify/data/sleep_review.dart';
import 'package:prognosify/models/mediaquery/mq.dart';

class SleepReviewCard extends StatelessWidget {
  final SleepReview sleepReview;

  const SleepReviewCard({super.key, required this.sleepReview});
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: mq(context, 100),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: mq(context, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      sleepReview.day,
                      style: TextStyle(fontSize: mq(context, 18)),
                    ),
                  ),
                  Text(
                    "Day",
                    style: TextStyle(
                        color: Colors.grey, fontSize: mq(context, 16)),
                  )
                ],
              ),
            ),
            Container(
              width: mq(context, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${sleepReview.timeSlept.inHours}:${sleepReview.timeSlept.inMinutes.remainder(60)} hrs",
                    style: TextStyle(fontSize: mq(context, 18)),
                  ),
                  Text("Time Slept",
                      style: TextStyle(
                          color: Colors.grey, fontSize: mq(context, 16)))
                ],
              ),
            ),
            Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sleepReview.satisfaction,
                    style: TextStyle(fontSize: mq(context, 18)),
                  ),
                  Text("Status",
                      style: TextStyle(
                          color: Colors.grey, fontSize: mq(context, 16)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
