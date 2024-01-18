import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/main.dart';
import 'package:prognosify/models/disease_card_data.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          title: Text(appTitle),
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context)
                  .goNamed(AppRouterConstants.navigationScreen, extra: 0);
            },
            icon: const Icon(Icons.arrow_back),
          )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Future Potential Health Issues",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ResultList(diseaseList: widget.answersList)
            ],
          ),
        ),
      ),
    );
  }
}
