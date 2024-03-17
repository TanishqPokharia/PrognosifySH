import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prognosify/data/sleep_review.dart';

class SleepingReviewListNotifier extends StateNotifier<List<SleepReview>> {
  SleepingReviewListNotifier() : super(futureSleepList);

  //update UI
  void addSleepingReview(SleepReview sleepReview) {
    state = [...state, sleepReview];
  }
}

List<SleepReview> futureSleepList = [
  SleepReview(
      timeSlept: Duration(hours: 5, minutes: 30),
      satisfaction: "Tired",
      dayIndex: 1),
  SleepReview(
      timeSlept: Duration(hours: 6, minutes: 15),
      satisfaction: "Satisfied",
      dayIndex: 2),
  SleepReview(
      timeSlept: Duration(hours: 7, minutes: 45),
      satisfaction: "Energized",
      dayIndex: 3),
  SleepReview(
      timeSlept: Duration(hours: 8, minutes: 0),
      satisfaction: "Energized",
      dayIndex: 4),
  SleepReview(
      timeSlept: Duration(hours: 6, minutes: 45),
      satisfaction: "Tired",
      dayIndex: 5),
];
