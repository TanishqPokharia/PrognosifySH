import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:http/http.dart' as http;
import 'package:prognosify/widgets/article_card.dart';
import 'package:prognosify/widgets/fitness_matrix.dart';
import 'package:prognosify/widgets/lifestyle_score.dart';

final articleProvider = FutureProvider<List>((ref) async {
  final response = await http.get(Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=757c6cf6262446f293b2ffb2ec84c03c"));
  if (response.statusCode == 200) {
    final decodedResponse = jsonDecode(response.body);

    return decodedResponse['articles'];
  } else {
    return [];
  }
});

final lifeStyleProvider = FutureProvider<dynamic>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  final fetchUserData =
      FirebaseFirestore.instance.collection("users").doc(user!.uid).get();

  final userData = await fetchUserData;
  final response = await http.post(
      Uri.parse("https://prognosifyassistantchatapi.onrender.com/LifestyleAI"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "age": userData['age'].toString(),
        "gender": userData['gender'],
        "bmi": (userData['weight'] / (userData['height'] * userData['height']))
            .toString(),
        "sleep": "8 hours",
        "steps": "20000",
        "calories": "2000"
      }));
  if (response.statusCode == 200) {
    final responseBody =
        response.body.replaceAll("\\n", " ").replaceAll(r"\\", "");

    print(jsonEncode(responseBody));
    final decodedResponse = jsonDecode(jsonDecode(responseBody));
    return await decodedResponse;
  } else {
    return null;
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
    final lifeStyleScore = ref.watch(lifeStyleProvider);
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi,",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: mq(context, 36),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser!.displayName ??
                              "User",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: mq(context, 36),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    FittedBox(
                      child: lifeStyleScore.when(
                        loading: () => CircularProgressIndicator(),
                        data: (data) {
                          if (data != null) {
                            print(data['Lifestyle_Score']);

                            return GestureDetector(
                                onTap: () {
                                  showDetailedLifestyleReview(context,
                                      data['Health_Insights'], data['Steps']);
                                },
                                child: Container(
                                  width: mq(context, 100),
                                  child: LifestyleScore(
                                      score: data['Lifestyle_Score']),
                                ));
                          } else {
                            return Container();
                          }
                        },
                        error: (error, stackTrace) {
                          print(error);
                          print(stackTrace);
                          return Container(
                            child: Text("Error"),
                          );
                        },
                      ),
                    )
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
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.all(mq(context, 15)),
              child: Text(
                "Assess your vulnerabilities and guard your tomorrow",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.all(mq(context, 20)),
              height: mq(context, 70),
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
              height: mq(context, 70),
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
                  return Text("Error loading articles");
                },
                data: (data) {
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

  void showDetailedLifestyleReview(
      BuildContext context, String insights, String steps) {
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return Dialog.fullscreen(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(mq(context, 20)),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Health Insights",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: mq(context, 40),
                          color: Colors.teal,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      insights,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                SizedBox(
                  height: mq(context, 50),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        "Further Steps To Consider",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: mq(context, 40),
                            color: Colors.teal,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(steps, style: Theme.of(context).textTheme.titleMedium),
                  ],
                )
              ],
            ),
          )),
        );
      },
    );
  }
}
