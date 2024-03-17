import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:flutter/material.dart';
import 'package:prognosify/screens/doctor/doctor_approved_screen.dart';
import 'package:prognosify/screens/doctor/doctor_home_screen.dart';
import 'package:prognosify/screens/doctor/doctor_profile_screen.dart';

class DoctorNavigationMenu extends StatefulWidget {
  const DoctorNavigationMenu({super.key});

  @override
  State<DoctorNavigationMenu> createState() => _DoctorNavigationMenuState();
}

class _DoctorNavigationMenuState extends State<DoctorNavigationMenu> {
  Widget? currentScreen = DoctorHomeScreen();
  int currentScreenIndex = 0;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
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
              iconData: Icons.medication_outlined,
              label: "Prescription",
              labelTextStyle: TextStyle(fontSize: mq(context, 14))),
          BottomBarItem(
              iconData: Icons.person,
              label: "Profle",
              labelTextStyle: TextStyle(fontSize: mq(context, 14)))
        ],
        selectedIndex: currentScreenIndex,
        onSelect: (index) {
          setState(() {
            switch (index) {
              case 0:
                setState(() {
                  currentScreenIndex = 0;
                  currentScreen = DoctorHomeScreen();
                });
                break;
              case 1:
                setState(() {
                  currentScreenIndex = 1;
                  currentScreen = DoctorApprovedScreen();
                });
                break;
              case 2:
                setState(() {
                  currentScreenIndex = 2;
                  currentScreen = const DoctorProfileScreen();
                });
                break;
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
