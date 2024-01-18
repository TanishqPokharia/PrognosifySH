import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:prognosify/models/notification/notification_services.dart';
import 'package:prognosify/widgets/frosted_glass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  TextEditingController textEditingController = TextEditingController();
  List<String> notificationTitles = [];
  Map<int, String> notificationIdToTitle = {};
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> loadStoredNotifications() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> savedNotificationList =
        sharedPreferences.getStringList("notifList") ?? [];
    print("$savedNotificationList savedNotifications");
    setState(() {
      notificationTitles = savedNotificationList;
    });
  }

  Future<void> storeNotifications(
      String notificationStore, DateTime convertedTime) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (notificationTitles.length < 5) {
      // Generate a unique ID for the notification
      int notificationId = DateTime.now().millisecondsSinceEpoch.hashCode;

      notificationTitles.add(notificationStore);
      notificationIdToTitle[notificationId] = notificationStore;

      sharedPreferences.setStringList("notifList", notificationTitles);
      print("$notificationTitles AFTER STORE");
      loadStoredNotifications();

      await NotificationServices.scheduleNotification(
        details: textEditingController.text.trim(),
        time: convertedTime,
        notificationID: notificationId,
      );
    } else {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You can only set 5 notifications at a time")));
      return;
    }
  }

  Future<void> removeNotification(String notification) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Find the unique ID associated with the custom identifier
    int? notificationId = notificationIdToTitle.entries
        .firstWhereOrNull((entry) => entry.value == notification)
        ?.key;

    if (notificationId != null) {
      // Cancel the notification using the unique ID
      await AwesomeNotifications().cancel(notificationId);
      notificationTitles.remove(notification);
      print("$notificationTitles TITLES after remove");

      sharedPreferences.setStringList("notifList", notificationTitles);
      print("$notificationTitles TITLES after set");

      // Remove the association from the map
      notificationIdToTitle.remove(notificationId);

      // Update the list and shared preferences by loading them again
      await loadStoredNotifications();

      setState(() {
        notificationTitles = [...notificationTitles];
      });
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Notification Cancelled")));
    } else {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Not Working")));
    }
  }

  @override
  void initState() {
    super.initState();
    print(notificationTitles.isEmpty
        ? "empty"
        : "$notificationIdToTitle before init");

    loadStoredNotifications();
    print(notificationTitles.isEmpty
        ? "empty"
        : "$notificationIdToTitle afte init");
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Center(
            child: Text(
              "Daily Routine",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 500,
            padding: EdgeInsets.all(10),
            child: notificationTitles.isNotEmpty
                ? ListView.builder(
                    itemCount: notificationTitles.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        background: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.75),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        key: ValueKey(notificationTitles[index]),
                        onDismissed: (direction) {
                          removeNotification(notificationTitles[index]);
                        },
                        child: FrostedGlassBox(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        _selectedTime
                                            .format(context)
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        notificationTitles[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20),
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
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                showDragHandle: true,
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: textEditingController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Do not leave body empty";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              label: Text(
                                "Body",
                                style: TextStyle(fontSize: 20),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => _selectTime(context),
                              child: Wrap(
                                spacing: 10,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Select Time',
                                    textAlign: TextAlign.center,
                                  ),
                                  Icon(Icons.access_time)
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                _selectedTime.format(context).toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final convertedTime = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              _selectedTime.hour,
                              _selectedTime.minute,
                              0,
                            );
                            storeNotifications(
                                textEditingController.text, convertedTime);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Wrap(
                          spacing: 10,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
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
            child: Text("Schedule Notification"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              await AwesomeNotifications().cancelAllSchedules();
            },
            child: Text("Cancel All Notification"),
          ),
        ],
      ),
    );
  }
}
