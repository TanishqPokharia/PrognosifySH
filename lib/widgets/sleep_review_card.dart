import 'package:flutter/material.dart';
import 'package:prognosify/data/sleep_review.dart';

class SleepReviewCard extends StatelessWidget {
  final SleepReview sleepReview;

  const SleepReviewCard({super.key, required this.sleepReview});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: 100,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sleepReview.day,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text(
                    "Day",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  )
                ],
              ),
            ),
            Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${sleepReview.timeSlept.inHours}:${sleepReview.timeSlept.inMinutes.remainder(60)} hrs",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text("Time Slept",
                      style: TextStyle(color: Colors.grey, fontSize: 12))
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
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text("Status",
                      style: TextStyle(color: Colors.grey, fontSize: 12))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
