import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prognosify/widgets/frosted_routine_card.dart';

class FrostedOptions extends StatelessWidget {
  const FrostedOptions({super.key, required this.child, required this.color});
  final Widget child;
  final Color color;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(
      borderRadius: BorderRadius.circular(mq(context, 15)),
      child: Container(
        margin: EdgeInsets.all(mq(context, 10)),
        padding: EdgeInsets.all(mq(context, 10)),
        child: Wrap(children: [
          Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(mq(context, 15)),
                      border:
                          Border.all(color: color.withOpacity(0.2), width: 5),
                      gradient: LinearGradient(colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.05)
                      ])),
                  child: child),
            ],
          ),
        ]),
      ),
    );
  }
}
