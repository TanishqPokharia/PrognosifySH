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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(
        Duration(
          seconds: 2,
        ), () {
      _user == null
          ? GoRouter.of(context).goNamed(AppRouterConstants.welcomeScreen)
          : GoRouter.of(context)
              .goNamed(AppRouterConstants.navigationScreen, extra: 0);
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
            height: 300,
            width: 200,
          ),
        )),
      ),
    );
  }
}
