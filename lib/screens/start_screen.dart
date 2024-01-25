import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/router/app_router_constants.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StartScreenState();
  }
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(mq(context, 15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(mq(context, 15)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi,",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: mq(context, 36),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName ?? "User",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: mq(context, 36),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: mq(context, 55),
          ),
          Container(
            padding: EdgeInsets.all(mq(context, 15)),
            child: Text(
              "Welcome To Prognosify",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: mq(context, 18)),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.all(mq(context, 15)),
            child: Text(
              "Assess your vulnerabilities and guard your tomorrow",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: mq(context, 18)),
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(mq(context, 10)),
                child: Text("Enter your age to proceed",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: mq(context, 18))),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mq(context, 150), vertical: mq(context, 25)),
                child: TextField(
                  textAlign: TextAlign.center,
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(mq(context, 15)),
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(mq(context, 10)),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2)),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(mq(context, 10)),
                      )),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: mq(context, 21)),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
                horizontal: mq(context, 45), vertical: mq(context, 10)),
            child: ElevatedButton(
                onPressed: () {
                  try {
                    int age = _textEditingController.text.toInt();
                    if (age > 110 || age < 1) return;
                    GoRouter.of(context).pushNamed(
                        AppRouterConstants.questionsScreen,
                        extra: age);
                  } on Exception catch (_) {
                    showDialog(
                        context: context,
                        builder: ((context) => Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(mq(context, 21))),
                            backgroundColor: Colors.white,
                            child: Padding(
                                padding: EdgeInsets.all(mq(context, 25)),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.all(mq(context, 35)),
                                        child: Text("Invalid Age!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                      ),
                                    ])))));
                  }
                },
                child: Text(
                  "Start Assessment",
                )),
          )
        ],
      ),
    );
  }
}
