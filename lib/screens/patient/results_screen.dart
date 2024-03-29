import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/main.dart';
import 'package:prognosify/data/disease_card_data.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:prognosify/widgets/result_list.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key, required this.answersList});
  final List<DiseaseCardData> answersList;
  @override
  State<StatefulWidget> createState() {
    return _ResultsScreen();
  }
}

class _ResultsScreen extends State<ResultsScreen> {
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          title: Text(appTitle),
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context)
                  .goNamed(AppRouterConstants.patientNavigationScreen);
            },
            icon: const Icon(Icons.arrow_back),
          )),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: mq(context, 25), horizontal: mq(context, 15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Future Potential Health Issues",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: mq(context, 24)),
              ),
              ResultList(diseaseList: widget.answersList)
            ],
          ),
        ),
      ),
    );
  }
}
