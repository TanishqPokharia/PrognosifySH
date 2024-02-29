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
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
                horizontal: mq(context, 45), vertical: mq(context, 10)),
            child: ElevatedButton(
                onPressed: () {
                  // }
                  GoRouter.of(context)
                      .goNamed(AppRouterConstants.questionsScreen);
                },
                child: const Text(
                  "Start Assessment",
                )),
          )
        ],
      ),
    );
  }
}
