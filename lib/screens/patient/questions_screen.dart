import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/main.dart';
import 'package:prognosify/data/disease_card_data.dart';
import 'package:prognosify/questions/questions.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:http/http.dart' as http;

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _QuestionsScreen();
  }
}

class _QuestionsScreen extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;
  List<String> answersList = [];
  List<int> bpList = [];

  List<DiseaseCardData> userDiseaseReport = [];
  late ProgressDialog progressDialog;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.normal);
    progressDialog.style(
        message: "Prognosifying...",
        elevation: 5,
        insetAnimCurve: Curves.easeIn,
        progressWidget: Image.asset("assets/stethoscope.gif"));
  }

  Future<Map<String, String>> getImageAndDescription(String diseaseName) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("diseases")
        .doc(diseaseName)
        .get();
    return {
      'image': snapshot.data()?['link'],
      'description': snapshot.data()?['desc'],
      'help': snapshot.data()?['help']
    };
  }

  getBloodPressure(List<int> bpList) {
    final bloodPressureResult =
        bpList[0] * 0.1 + bpList[1] * 0.3 + bpList[2] * 0.3 + bpList[3] * 0.3;
    return bloodPressureResult;
  }

  Future<void> getUserDiseases(List<String> userResponse) async {
    progressDialog.show();
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .get();
      Uri apiUrl = Uri.parse('https://prognosify.onrender.com/prognosify');
      final bloodPressureResult = getBloodPressure(bpList);
      Map<String, String> requestBody = {
        "fever": userResponse[0],
        "cough": userResponse[1],
        "fatigue": userResponse[2],
        "age": snapshot.data()!['age'].toString(),
        "gender": snapshot.data()?['gender'],
        "cholestrol level": bloodPressureResult >= 0.6 ? "High" : "Normal",
        "difficulty in breathing": userResponse[3],
        "blood pressure": bloodPressureResult >= 0.6 ? "High" : "Normal"
      };

      http.Response response = await http.post(apiUrl, body: requestBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> apiResults = jsonResponse['Results'];
        if (apiResults.isNotEmpty) {
          for (int i = 0; i < apiResults.length; i++) {
            final Map<String, String> diseaseData =
                await getImageAndDescription(apiResults[i]['Disease']);
            userDiseaseReport.add(DiseaseCardData(
                percentage: apiResults[i]['Likelihood'],
                disease: apiResults[i]['Disease'],
                imageLink: diseaseData['image'],
                diseaseDescription: diseaseData['description'],
                symptoms: List<String>.from(json.decode(
                  apiResults[i]['Symptoms'],
                )),
                precautions: List<String>.from(
                    json.decode(apiResults[i]['Precautions'])),
                routines: List<String>.from(
                    json.decode(apiResults[i]['Daily_Health_Routine'])),
                help: diseaseData['help']));
          }
          final topThreeDiseasesName = [
            apiResults[0]['Disease'],
            apiResults[1]['Disease'],
            apiResults[2]['Disease']
          ];
          final topThreeDiseasesPercentage = [
            apiResults[0]['Likelihood'],
            apiResults[1]['Likelihood'],
            apiResults[2]['Likelihood']
          ];
          final topThreeDiseasesPrecautions = {
            "0": List<String>.from(json.decode(apiResults[0]['Precautions'])),
            "1": List<String>.from(json.decode(apiResults[1]['Precautions'])),
            "2": List<String>.from(json.decode(apiResults[2]['Precautions']))
          };
          final topThreeDiseasesSymptoms = {
            "0": List<String>.from(json.decode(
              apiResults[0]['Symptoms'],
            )),
            "1": List<String>.from(json.decode(
              apiResults[1]['Symptoms'],
            )),
            "2": List<String>.from(json.decode(
              apiResults[2]['Symptoms'],
            )),
          };

          final topThreeRoutines = {
            "0": List<String>.from(json.decode(
              apiResults[0]['Daily_Health_Routine'],
            )),
            "1": List<String>.from(json.decode(
              apiResults[1]['Daily_Health_Routine'],
            )),
            "2": List<String>.from(json.decode(
              apiResults[2]['Daily_Health_Routine'],
            )),
          };

          final currentUser = FirebaseAuth.instance.currentUser;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .update(
            {
              // "name": currentUser.displayName,
              // "email": currentUser.email,
              "topDiseases": topThreeDiseasesName,
              "topPercentage": topThreeDiseasesPercentage,
              'topDiseasesPrecautions': topThreeDiseasesPrecautions,
              'topDiseasesSymptoms': topThreeDiseasesSymptoms,
              'topDiseasesRoutines': topThreeRoutines
            },
          );
          progressDialog.hide();
          if (!mounted) {
            return;
          }
          GoRouter.of(context).goNamed(AppRouterConstants.resultsScreen,
              extra: userDiseaseReport);
        } else {
          progressDialog.hide();
          if (!mounted) {
            return;
          }
          GoRouter.of(context)
              .goNamed(AppRouterConstants.patientNavigationScreen);
          showDialog(
              context: context,
              builder: ((context) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(mq(context, 21))),
                  backgroundColor: Colors.white,
                  child: Padding(
                      padding: EdgeInsets.all(mq(context, 25)),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(mq(context, 35)),
                              child: Text(
                                  "Invalid server response. Please try again later.",
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ),
                          ])))));
        }
      }
    } on SocketException catch (_) {
      progressDialog.hide();
      if (!mounted) {
        return;
      }
      showDialog(
          context: context,
          builder: ((context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(mq(context, 21))),
              backgroundColor: Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(mq(context, 25)),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(mq(context, 35)),
                          child: Text(
                              "Invalid Response. Please check your internet connection",
                              style: Theme.of(context).textTheme.titleSmall),
                        ),
                      ])))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: mq(context, 20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(mq(context, 15)),
                  child: Text(
                    currentQuestion.question,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: mq(context, 15),
                ),
                ...currentQuestion.options.map((option) {
                  return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: mq(context, 25),
                          vertical: mq(context, 15)),
                      width: double.infinity,
                      padding: EdgeInsets.all(mq(context, 15)),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (currentQuestionIndex < 4) {
                                answersList.add(option);
                              } else {
                                if (option == "Yes") {
                                  bpList.add(1);
                                } else {
                                  bpList.add(0);
                                }
                              }
                              if (currentQuestionIndex ==
                                  questions.length - 1) {
                                getUserDiseases(answersList);
                                // GoRouter.of(context).goNamed(
                                //     AppRouterConstants.resultsScreen,
                                //     extra: userDiseaseReport);
                                return;
                              }
                              currentQuestionIndex++;
                            });
                          },
                          child: Text(option)));
                }),
                Container(
                  margin: EdgeInsets.all(mq(context, 20)),
                  child: Text(
                    "${currentQuestionIndex + 1}/${questions.length}",
                    style: TextStyle(
                        color: Colors.grey, fontSize: mq(context, 24)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
