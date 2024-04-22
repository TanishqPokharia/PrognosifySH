import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LifestyleScore extends StatelessWidget {
  const LifestyleScore({super.key, required this.score});

  final int score;
  Color get color {
    if (score > 70) {
      return Colors.green;
    } else if (score > 40) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // padding: EdgeInsets.all(mq(context, 10)),
          margin: EdgeInsets.all(mq(context, 15)),
          child: CircularPercentIndicator(
            radius: mq(context, 40),
            progressColor: color,
            lineWidth: 6,
            percent: score / 100,
            animation: true,
            animationDuration: 2000,
            center: Text(
              score.toString(),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: mq(context, 24),
                  color: color,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Text(
          "Lifestyle Score",
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
