import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/main.dart';
import 'package:prognosify/models/mediaquery/mq.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:http/http.dart' as http;
import 'package:prognosify/widgets/article_card.dart';
import 'package:prognosify/widgets/fitness_matrix.dart';
import 'package:prognosify/widgets/frosted_routine_card.dart';
import 'package:prognosify/widgets/frosted_options.dart';

final articleProvider = FutureProvider<List>((ref) async {
  final response = await http.get(Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=757c6cf6262446f293b2ffb2ec84c03c"));
  final decodedResponse = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return decodedResponse['articles'];
  } else {
    throw Exception("Failed to load articles");
  }
});

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleList = ref.watch(articleProvider);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(mq(context, 15)),
      child: SingleChildScrollView(
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
              margin: EdgeInsets.all(mq(context, 20)),
              child: TextButton(
                  style: Theme.of(context).textButtonTheme.style!.copyWith(
                      elevation: MaterialStatePropertyAll(10),
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      foregroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.primary)),
                  onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(AppRouterConstants.questionsScreen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment),
                      SizedBox(
                        width: mq(context, 10),
                      ),
                      Text(
                        "Start Assessment",
                        style: TextStyle(fontSize: mq(context, 20)),
                      ),
                    ],
                  )),
            ),
            Container(
              margin: EdgeInsets.all(mq(context, 20)),
              child: TextButton(
                  style: Theme.of(context).textButtonTheme.style!.copyWith(
                      elevation: MaterialStatePropertyAll(10),
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      foregroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.primary)),
                  onPressed: () {
                    GoRouter.of(context)
                        .pushNamed(AppRouterConstants.contactedDoctorsScreen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history),
                      SizedBox(
                        width: mq(context, 10),
                      ),
                      Text("Contacted Doctors",
                          style: TextStyle(fontSize: mq(context, 20)))
                    ],
                  )),
            ),
            FitnessMatrix(),
            Container(
              margin: EdgeInsets.all(mq(context, 20)),
              child: FittedBox(
                child: Text(
                  "Latest Health Articles",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(mq(context, 10)),
              child: articleList.when(
                loading: () => CircularProgressIndicator(),
                error: (error, stackTrace) {
                  print(articleList);
                  return Text("Error loading articles");
                },
                data: (data) {
                  data.forEach((element) => print(element));
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...data.map((article) => ArticleCard(
                              author: article['source']['name'],
                              title: article['title'],
                              articleUrl: article['url'],
                              imageUrl: article['urlToImage'],
                            ))
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
