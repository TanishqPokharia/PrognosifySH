import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/main.dart';
import 'package:prognosify/router/app_router_constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(mq(context, 60)),
              child: Center(
                child: Hero(
                  tag: "Tag",
                  child: Image.asset(
                    'assets/applogo.png',
                    height: mq(context, 350),
                    width: mq(context, 350),
                  ),
                ),
              ),
            ),
            Expanded(
                child: SizedBox(
              width: double.infinity,
              child: Card(
                  margin: EdgeInsets.zero,
                  color: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(mq(context, 45)),
                        topRight: Radius.circular(mq(context, 45))),
                  ),
                  child: Column(
                    children: [
                      Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: mq(context, 45), left: mq(context, 35)),
                            child: Text(
                              "Welcome to Prognosify",
                              style: TextStyle(
                                  fontSize: mq(context, 50),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: mq(context, 35), top: mq(context, 15)),
                            child: Text(
                              "Guard yourself from future risks and diseases",
                              style: TextStyle(
                                fontSize: mq(context, 25),
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: mq(context, 45),
                            right: mq(context, 35),
                            left: mq(context, 35)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: mq(context, 160),
                              height: mq(context, 55),
                              child: ElevatedButton(
                                  onPressed: () {
                                    GoRouter.of(context).pushNamed(
                                        AppRouterConstants.signUpScreen);
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: mq(context, 25),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: mq(context, 160),
                              height: mq(context, 55),
                              child: ElevatedButton(
                                  onPressed: () {
                                    GoRouter.of(context).pushNamed(
                                        AppRouterConstants.signInScreen);
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(fontSize: mq(context, 25)),
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ))
          ],
        ),
      ),
    );
  }
}
