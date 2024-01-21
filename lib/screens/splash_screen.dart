import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/main.dart';
import 'package:prognosify/router/app_router_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final User? _user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();

    Future.delayed(
        const Duration(
          seconds: 2,
        ), () {
      _user == null
          ? GoRouter.of(context).goNamed(AppRouterConstants.welcomeScreen)
          : GoRouter.of(context).goNamed(AppRouterConstants.navigationScreen);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
