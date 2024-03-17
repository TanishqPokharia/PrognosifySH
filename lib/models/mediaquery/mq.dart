import 'package:flutter/material.dart';

class MQ {
  static double size(BuildContext context, double dimension) {
    return MediaQuery.of(context).size.height * (dimension / 1000);
  }
}
