import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/router/app_router_constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  showAuthBottomModalSheet(
      {required context,
      required heading,
      required onSignIn,
      required onSignUp}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) {
        return Container(
          height: mq(context, 400),
          margin: EdgeInsets.all(mq(context, 10)),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(mq(context, 20)),
                padding: EdgeInsets.all(mq(context, 10)),
                child: Text(
                  heading,
                  style: TextStyle(
                      fontSize: mq(context, 30),
                      color: Colors.teal,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(mq(context, 20)),
                padding: EdgeInsets.all(mq(context, 10)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mq(context, 10)),
                  color: Colors.teal,
                ),
                child: TextButton(
                    onPressed: onSignUp,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white, fontSize: mq(context, 24)),
                    )),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(mq(context, 20)),
                padding: EdgeInsets.all(mq(context, 10)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mq(context, 10)),
                  color: Colors.teal,
                ),
                child: TextButton(
                    onPressed: onSignIn,
                    child: Text("Sign In",
                        style: TextStyle(
                            color: Colors.white, fontSize: mq(context, 24)))),
              )
            ],
          ),
        );
      },
    );
  }

  doctorAuthModal(context) {
    showAuthBottomModalSheet(
        context: context,
        heading: "Doctor",
        onSignIn: () {
          GoRouter.of(context).pushNamed(AppRouterConstants.signInScreen);
        },
        onSignUp: () {
          GoRouter.of(context).pushNamed(AppRouterConstants.doctorSignUpScreen);
        });
  }

  patientAuthModal(context) {
    showAuthBottomModalSheet(
        context: context,
        heading: "Patient",
        onSignIn: () {
          GoRouter.of(context).pushNamed(AppRouterConstants.signInScreen);
        },
        onSignUp: () {
          GoRouter.of(context)
              .pushNamed(AppRouterConstants.patientSignUpScreen);
        });
  }

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
                                    // GoRouter.of(context).pushNamed(
                                    //     AppRouterConstants.signUpScreen);
                                    doctorAuthModal(context);
                                  },
                                  child: Text(
                                    "Doctor",
                                    style: TextStyle(
                                      fontSize: mq(context, 24),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: mq(context, 160),
                              height: mq(context, 55),
                              child: ElevatedButton(
                                  onPressed: () {
                                    // GoRouter.of(context).pushNamed(
                                    //     AppRouterConstants.signInScreen);
                                    patientAuthModal(context);
                                  },
                                  child: Text(
                                    "Patient",
                                    style: TextStyle(fontSize: mq(context, 24)),
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
