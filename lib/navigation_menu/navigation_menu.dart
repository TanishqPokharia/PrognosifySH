import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:flutter/material.dart';
import 'package:prognosify/main.dart';
import 'package:prognosify/screens/profile_screen.dart';
import 'package:prognosify/screens/questions_screen.dart';
import 'package:prognosify/screens/routine_screen.dart';
import 'package:prognosify/screens/start_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationMenu extends StatefulWidget {
  NavigationMenu({super.key, required this.currentScreenIndex});
  int currentScreenIndex;

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  Widget? currentScreen = StartScreen();
  // int currentScreenIndex = 0;

  showInvalidApiResponseDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.white,
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          "Invalid Response. Please try again later.",
                          style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ])))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomBarBubble(
        color: kColorScheme.primary,
        items: [
          BottomBarItem(iconData: Icons.assessment, label: "Assessment"),
          BottomBarItem(iconData: Icons.checklist, label: "Routine"),
          BottomBarItem(iconData: Icons.person, label: "Profile"),
        ],
        selectedIndex: widget.currentScreenIndex,
        onSelect: (index) {
          setState(() {
            switch (index) {
              case 0:
                setState(() {
                  widget.currentScreenIndex = 0;
                });
                currentScreen = StartScreen();
                break;
              case 1:
                setState(() {
                  widget.currentScreenIndex = 1;
                });
                currentScreen = RoutineScreen();
                break;
              case 2:
                setState(() {
                  widget.currentScreenIndex = 2;
                });
                currentScreen = ProfileScreen();
                break;
            }
          });
        },
      ),
      body: SafeArea(
        child: Container(
          child: currentScreen,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.onInverseSurface,
            Theme.of(context).colorScheme.primary
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        ),
      ),
    );
  }
}
