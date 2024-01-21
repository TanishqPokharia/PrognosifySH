import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'prognosify_notification.g.dart';

@HiveType(typeId: 1)
class PrognosifyNotification {
  @HiveField(0)
  final String time;

  @HiveField(1)
  final String body;

  @HiveField(2)
  final int id;

  const PrognosifyNotification(
      {required this.time, required this.body, required this.id});
}
