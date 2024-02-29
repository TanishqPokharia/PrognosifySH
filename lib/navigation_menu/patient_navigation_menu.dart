import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prognosify/models/hive_model/prognosify_notification.dart';
import 'package:prognosify/screens/assistant/assistant_screen.dart';
import 'package:prognosify/screens/profile_screen.dart';
import 'package:prognosify/screens/routine_screen.dart';
import 'package:prognosify/screens/start_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientNavigationMenu extends StatefulWidget {
  const PatientNavigationMenu({super.key});

  @override
  State<PatientNavigationMenu> createState() => _PatientNavigationMenuState();
}

class _PatientNavigationMenuState extends State<PatientNavigationMenu> {
  Widget? currentScreen = const StartScreen();
  int currentScreenIndex = 0;
  bool areNotificationsStored = false;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  showInvalidApiResponseDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(mq(context, 21))),
            backgroundColor: Colors.white,
            child: Padding(
                padding: EdgeInsets.all(mq(context, 25)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(mq(context, 35)),
                        child: Text(
                          "Invalid Response. Please try again later.",
                          style: GoogleFonts.dmSans(
                              fontSize: mq(context, 19),
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ])))));
  }

  Future getHiveBox() async {
    await Hive.initFlutter("prognosify_notifications_folder");
    if (Hive.isAdapterRegistered(1) == false) {
      Hive.registerAdapter(PrognosifyNotificationAdapter());
    }
    var box = await Hive.openBox("prognosifynotifications");
    if (box.isNotEmpty) {
      setState(() {
        areNotificationsStored = true;
      });
    }
  }

  Future<void> initialize() async {
    await getHiveBox();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomBarBubble(
        height: mq(context, 80),
        color: Theme.of(context).colorScheme.primary,
        items: [
          BottomBarItem(
              iconData: Icons.home,
              label: "Home",
              labelTextStyle: TextStyle(fontSize: mq(context, 14))),
          BottomBarItem(
              iconData: Icons.checklist,
              label: "Routine",
              labelTextStyle: TextStyle(fontSize: mq(context, 14))),
          BottomBarItem(
              iconData: Icons.person,
              label: "Profile",
              labelTextStyle: TextStyle(fontSize: mq(context, 14))),
          BottomBarItem(
              iconData: Icons.chat,
              label: "Assistant",
              labelTextStyle: TextStyle(fontSize: mq(context, 14)))
        ],
        selectedIndex: currentScreenIndex,
        onSelect: (index) {
          setState(() {
            switch (index) {
              case 0:
                setState(() {
                  currentScreenIndex = 0;
                });
                currentScreen = const StartScreen();
                break;
              case 1:
                setState(() {
                  currentScreenIndex = 1;
                });
                currentScreen = RoutineScreen(
                  areNotificationsStored: areNotificationsStored,
                );
                break;
              case 2:
                setState(() {
                  currentScreenIndex = 2;
                });
                currentScreen = const ProfileScreen();
                break;
              case 3:
                setState(() {
                  currentScreenIndex = 3;
                });
                currentScreen = const PrognosifyAssistant();
            }
          });
        },
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.onInverseSurface,
            Theme.of(context).colorScheme.primary
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: currentScreen,
        ),
      ),
    );
  }
}
