import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlassBox extends StatelessWidget {
  const FrostedGlassBox(
      {super.key,
      // required this.width,
      // required this.height,
      required this.child});
  // final double width;
  // final double height;
  final Widget child;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
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
                child: Container(),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mq(context, 15)),
                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                    gradient: LinearGradient(colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05)
                    ])),
                child: child,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
