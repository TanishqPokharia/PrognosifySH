import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final String title;
  final Color color;

  const Indicator({super.key, required this.title, required this.color});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: mq(context, 50),
      width: mq(context, 140),
      padding: EdgeInsets.all(mq(context, 10)),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: mq(context, 15),
              width: mq(context, 15),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.rectangle,
              ),
            ),
            SizedBox(
              width: mq(context, 10),
            ),
            Container(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold, fontSize: mq(context, 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
