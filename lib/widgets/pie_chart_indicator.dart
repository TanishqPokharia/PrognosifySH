import 'package:flutter/material.dart';
import 'package:prognosify/models/mediaquery/mq.dart';

class Indicator extends StatelessWidget {
  final String title;
  final Color color;

  const Indicator({super.key, required this.title, required this.color});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: MQ.size(context, 50),
      width: MQ.size(context, 140),
      padding: EdgeInsets.all(MQ.size(context, 10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MQ.size(context, 15),
            width: MQ.size(context, 15),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
          ),
          SizedBox(
            width: MQ.size(context, 10),
          ),
          Container(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold, fontSize: MQ.size(context, 16)),
            ),
          )
        ],
      ),
    );
  }
}
