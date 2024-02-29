import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/router/app_router_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final User? _user = FirebaseAuth.instance.currentUser;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(
        const Duration(
          seconds: 3,
        ), () async {
      if (_user == null) {
        GoRouter.of(context).goNamed(AppRouterConstants.welcomeScreen);
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .get();

      if (!context.mounted) {
        return;
      }

      if (snapshot.exists) {
        GoRouter.of(context)
            .goNamed(AppRouterConstants.patientNavigationScreen);
      } else {
        GoRouter.of(context).goNamed(AppRouterConstants.doctorNavigationScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Hero(
          tag: "Tag",
          child: Image.asset(
            'assets/applogo.png',
            height: mq(context, 350),
            width: mq(context, 250),
          ),
        )),
      ),
    );
  }
}
