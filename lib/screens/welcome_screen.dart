import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              margin: EdgeInsets.all(50),
              child: Center(
                child: Hero(
                  tag: "Tag",
                  child: Image.asset(
                    'assets/applogo.png',
                    height: 300,
                    width: 300,
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
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                  ),
                  child: Column(
                    children: [
                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40, left: 30),
                            child: Text(
                              "Welcome to Prognosify",
                              style: TextStyle(
                                  fontSize: 45,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, top: 10),
                            child: Text(
                              "Guard yourself from future risks and diseases",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40, right: 30, left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    GoRouter.of(context).pushNamed(
                                        AppRouterConstants.signUpScreen);
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 150,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    GoRouter.of(context).pushNamed(
                                        AppRouterConstants.signInScreen);
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(fontSize: 20),
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
