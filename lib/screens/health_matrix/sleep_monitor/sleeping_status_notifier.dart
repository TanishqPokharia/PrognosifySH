import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prognosify/data/sleep_review.dart';
import 'package:prognosify/screens/health_matrix/sleep_monitor/sleep_monitor_screen.dart';

class SleepingStatusNotifier extends StateNotifier<bool> {
  SleepingStatusNotifier() : super(false);

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  void updateSleepingStatus(WidgetRef ref, BuildContext context,
      DateTime? sleepStartTime, String day) {
    if (state) {
      sleepStartTime = ref.watch(sleepStartTimeProvider);
      final timeSlept = DateTime.now().difference(sleepStartTime!);
      print(timeSlept);
      getUserSleepSatisfaction(context, ref, timeSlept);
    } else {
      ref.watch(sleepStartTimeProvider.notifier).state = DateTime.now();
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            alignment: Alignment.center,
            height: mq(context, 200),
            width: mq(context, 200),
            child: Text(
              "Sweet Dreams!",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      );
    }
    state = !state;
  }

  void getUserSleepSatisfaction(
      BuildContext context, WidgetRef widgetRef, Duration timeSlept) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        insetAnimationDuration: Duration(milliseconds: 2000),
        insetAnimationCurve: Curves.easeInSine,
        child: Container(
          height: 400,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(mq(context, 10)),
                child: Text(
                  "Sleep Review",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Image.asset("assets/satisfaction_level_image.png"),
              Consumer(
                builder: (_, WidgetRef ref, __) {
                  return Slider(
                    allowedInteraction: SliderInteraction.tapAndSlide,
                    value: ref.watch(sliderValueProvider),
                    min: 0.0,
                    max: 2.0,
                    label: ref.watch(satisfactionProvider),
                    divisions: 2,
                    activeColor: Colors.purple,
                    inactiveColor: Colors.grey,
                    onChanged: (value) {
                      ref.read(sliderValueProvider.notifier).state = value;
                      switch (value) {
                        case 0:
                          ref.read(satisfactionProvider.notifier).state =
                              "Tired";
                          break;
                        case 1:
                          ref.read(satisfactionProvider.notifier).state =
                              "Satisfied";
                          break;
                        case 2:
                          ref.read(satisfactionProvider.notifier).state =
                              "Energized";
                          break;
                        default:
                          ref.read(satisfactionProvider.notifier).state = "";
                          break;
                      }
                    },
                  );
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    widgetRef
                        .read(sleepingReviewListProvider.notifier)
                        .addSleepingReview(SleepReview(
                            timeSlept: timeSlept,
                            satisfaction: widgetRef.read(satisfactionProvider),
                            dayIndex: 6));

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sleep review submitted')),
                    );
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
