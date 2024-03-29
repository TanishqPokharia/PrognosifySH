import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prognosify/models/hive_model/prognosify_notification.dart';
import 'package:prognosify/models/notification/notification_services.dart';
import 'package:prognosify/widgets/frosted_routine_card.dart';

class RoutineScreen extends StatefulWidget {
  RoutineScreen({super.key, required this.areNotificationsStored});
  bool areNotificationsStored;
  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<PrognosifyNotification> notificationList = [];

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? chosenTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (chosenTime != null && chosenTime != selectedTime) {
      setState(() {
        selectedTime = chosenTime;
      });
    }
  }

  Future<void> loadNotifications() async {
    var notificationsHiveBox = Hive.box("prognosifynotifications");
    setState(() {
      notificationsHiveBox.toMap().forEach((key, value) {
        notificationList.add(value);
      });
      if (notificationsHiveBox.isNotEmpty) {
        setState(() {
          widget.areNotificationsStored = true;
        });
      }
    });
  }

  Future<void> storeNotifications(
      PrognosifyNotification notification, DateTime convertedTime) async {
    var notificationsHiveBox = Hive.box("prognosifynotifications");
    notificationsHiveBox.put(notification.id, notification);
    setState(() {
      notificationList.add(notification);
      if (widget.areNotificationsStored == false) {
        widget.areNotificationsStored = true;
      }
    });
    await NotificationServices.scheduleNotification(
        details: textEditingController.text,
        time: convertedTime,
        notificationID: notification.id);
    // loadNotifications();
  }

  Future<void> removeNotification(int id) async {
    var notificationsHiveBox = Hive.box("prognosifynotifications");
    notificationsHiveBox.delete(id);
    setState(() {
      notificationList.removeWhere((element) => element.id == id);
    });
    await AwesomeNotifications().cancel(id);
    // loadNotifications();
  }

  Future initialize() async {
    // await getHiveBox();
    await loadNotifications();
  }

  @override
  void initState() {
    super.initState();
    // getHiveBox().then((_) {
    //   loadNotifications();
    // });
    initialize();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(mq(context, 15)),
      child: Column(
        children: [
          Center(
            child: Text(
              "Daily Routine",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: mq(context, 41),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Container(
            margin: EdgeInsets.all(mq(context, 15)),
            height: mq(context, 500),
            padding: EdgeInsets.all(mq(context, 15)),
            child: widget.areNotificationsStored
                ? ListView.builder(
                    itemCount: notificationList.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        background: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.75),
                          margin:
                              EdgeInsets.symmetric(horizontal: mq(context, 25)),
                        ),
                        key: ValueKey(notificationList[index]),
                        onDismissed: (direction) {
                          removeNotification(notificationList[index].id);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Notification removed")));
                        },
                        child: FrostedGlassRoutineCard(
                          child: Container(
                            padding: EdgeInsets.all(mq(context, 10)),
                            margin: EdgeInsets.all(mq(context, 10)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          notificationList[index].time,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: mq(context, 21)),
                                        ),
                                      ),
                                      Text(
                                        notificationList[index].body,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: mq(context, 25)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    child: Text(
                      "Follow a healthy routine to prevent future diseases! Set daily routines now!",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: mq(context, 23)),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
          SizedBox(
            height: mq(context, 25),
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                showDragHandle: true,
                context: context,
                builder: (context) {
                  final TimeOfDay time = TimeOfDay.now();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(mq(context, 25)),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: textEditingController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Do not leave routine empty";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              label: Text(
                                "Routine",
                                style: TextStyle(fontSize: mq(context, 25)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(mq(context, 25))),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(mq(context, 25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => selectTime(context),
                              child: Wrap(
                                spacing: mq(context, 15),
                                alignment: WrapAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Select Time',
                                    textAlign: TextAlign.center,
                                  ),
                                  Icon(Icons.access_time)
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(mq(context, 25)),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: mq(context, 2),
                                      color: Colors.black),
                                  borderRadius:
                                      BorderRadius.circular(mq(context, 15))),
                              child: Text(
                                selectedTime.format(context),
                                style: TextStyle(fontSize: mq(context, 21)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mq(context, 25),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final convertedTime = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              selectedTime.hour,
                              selectedTime.minute,
                              0,
                            );

                            storeNotifications(
                                PrognosifyNotification(
                                    time:
                                        selectedTime.format(context).toString(),
                                    body: textEditingController.text,
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .hashCode),
                                convertedTime);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Routine Notification saved")));
                          }
                        },
                        child: Wrap(
                          spacing: mq(context, 15),
                          alignment: WrapAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Schedule Notification",
                              textAlign: TextAlign.center,
                            ),
                            Icon(Icons.notification_add)
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("Schedule Routine Notification"),
          ),
          SizedBox(
            height: mq(context, 25),
          ),
          ElevatedButton(
            onPressed: () async {
              await AwesomeNotifications().cancelAllSchedules();
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("All Routine Notifications Cancelled")));
            },
            child: const Text("Cancel All Routine Notifications"),
          ),
        ],
      ),
    );
  }
}
