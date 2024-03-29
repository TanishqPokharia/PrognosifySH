import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/cloud_notification/cloud_notifications.dart';
import 'package:dob_input_field/dob_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:prognosify/data/medication.dart';
import 'package:prognosify/data/patient_card_data.dart';
import 'package:prognosify/data/routine.dart';
import 'package:flutter/material.dart';
import 'package:prognosify/screens/health_matrix/sleep_monitor/sleep_review_list_notifier.dart';
import 'package:prognosify/widgets/medication_form.dart';
import 'package:prognosify/widgets/medication_prescription.dart';
import 'package:prognosify/widgets/routine_form.dart';
import 'package:prognosify/widgets/routine_prescription.dart';
import 'package:prognosify/widgets/saved_medication_card.dart';
import 'package:prognosify/widgets/saved_routine_card.dart';
import 'package:http/http.dart' as http;

List<MedicationForm> medicationPrescriptionList = [];
List<RoutineForm> routinePrescriptionList = [];

List<Medication> savedMedicationList = [];
List<Routine> savedRoutinesList = [];

class WritePrescriptionScreen extends StatefulWidget {
  const WritePrescriptionScreen({super.key, required this.patientData});
  final PatientCardData patientData;

  @override
  State<WritePrescriptionScreen> createState() =>
      _WritePrescriptionScreenState();
}

class _WritePrescriptionScreenState extends State<WritePrescriptionScreen> {
  String generalInstructions = "";
  String dietaryRecommendations = "";
  String activityRestrictions = "";
  String additionalInstructions = "";
  bool waiting = false;
  final _formKey = GlobalKey<FormState>();

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  void openMedicationModal(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        context: context,
        builder: (context) {
          return Container(
              height: double.infinity,
              width: double.infinity,
              child: MedicationPrescription());
        }).then((value) {
      setState(() {});
    });
  }

  void openRoutineModal(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        context: context,
        builder: (context) {
          return Container(
              height: double.infinity,
              width: double.infinity,
              child: RoutinePrescription());
        }).then((value) {
      setState(() {});
    });
  }

  Map<String, dynamic> _convertListToMap(List<dynamic> list) {
    Map<String, dynamic> result = {};

    for (int i = 0; i < list.length; i++) {
      String key = "${list[i].runtimeType} ${i + 1}";
      Map<String, dynamic> entry = {};

      if (list[i] is Medication) {
        entry["Name"] = list[i].name;
        entry["Dosage"] = list[i].dosage;
        entry["Frequency"] = list[i].frequency;
        entry["Route"] = list[i].route;
        entry["Start Date"] = list[i].startDate;
        entry["End Date"] = list[i].endDate;
      } else if (list[i] is Routine) {
        entry["Name"] = list[i].name;
        entry["Duration"] = list[i].duration;
        entry["Frequency"] = list[i].frequency;
        entry["Start Time"] = list[i].startTime;
        entry["End Time"] = list[i].endTime;
      }

      result[key] = entry;
    }

    return result;
  }

  Future<void> onPrescriptionSubmit(context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Map<String, dynamic> result = {
        "email": widget.patientData.email,
        "doc_name": user!.displayName,
        "MEDICATION": _convertListToMap(savedMedicationList),
        "ROUTINES": _convertListToMap(savedRoutinesList),
        "INSTRUCTIONS": {
          "General": generalInstructions,
          "Dietary": dietaryRecommendations,
          "Restriction": activityRestrictions,
          "Additional": additionalInstructions
        }
      };
      print(widget.patientData.email);
      final encodedResult = jsonEncode(result);

      //mail the prescription to the user
      await http
          .post(Uri.parse("https://prognosify.onrender.com/mail_prescription"),
              headers: {'Content-Type': 'application/json'},
              body: encodedResult)
          .then((value) {
        if (value.statusCode == 200) {
          final response = value.body;
          final status = jsonDecode(response);
          print("Status:${status['status']}");
          if (status['status'] == "true") {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Prescription has been sent!")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "Error in sending perscription, please try again later")));
          }
        }
      }).catchError((error) => print(error));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all the details")));
    }

    //send notification to patient

    var data = {
      'to': widget.patientData.token,
      'notification': {
        'title': 'Prognosfiy',
        'body':
            'Dr. ${FirebaseAuth.instance.currentUser!.displayName} has sent prescription',
        "sound": "jetsons_doorbell.mp3"
      },
      "android": {
        "notification": {"channel_id": "PrognosifyChannelID"}
      },
    };

    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAIUQVqGE:APA91bETdB-aGi1Ln4lK9Hcbo1i7jFHZNFQ6tT1MIyD5s_phEBHjgdkcgO5fIpGhjeHxmGUGVxcdnhdZZVIZamvJWw5UmyaLSuRaQWE5_HJy0fGrVFuC_LwZVQcZH9IsedD95cOqx_dr'
        }).then((value) {
      if (kDebugMode) {
        print(value.body.toString());
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });

    //remove from approved screen

    final snapshot = await FirebaseFirestore.instance
        .collection("doctors")
        .doc(user!.uid)
        .get();

    final List approvedPatients = snapshot.data()!['approvedPatients'];
    approvedPatients
        .removeWhere((element) => element['email'] == widget.patientData.email);

    await FirebaseFirestore.instance
        .collection("doctors")
        .doc(user.uid)
        .update({"approvedPatients": approvedPatients});

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Prescription has been sent to ${widget.patientData.name}")));

    GoRouter.of(context).pop();

    print("Done");
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Mon', style: style);
        break;
      case 1:
        text = const Text('Tue', style: style);
        break;
      case 2:
        text = const Text('Wed', style: style);
        break;
      case 3:
        text = const Text('Thu', style: style);
        break;
      case 4:
        text = const Text('Fri', style: style);
        break;
      case 5:
        text = const Text('Sat', style: style);
        break;
      case 6:
        text = const Text('Sun', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 2:
        text = '2hr';
        break;
      case 4:
        text = '4hr';
        break;
      case 6:
        text = '6hr';
        break;
      case 8:
        text = '8hr';
        break;
      case 10:
        text = '10hr';
        break;
      case 12:
        text = '12hr';
        break;

      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prescribe"),
      ),
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: mq(context, 50)),
                ),
                Container(
                  margin: EdgeInsets.all(mq(context, 30)),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Patient Lifestyle Data",
                    style: TextStyle(
                        fontSize: mq(context, 30),
                        color: Colors.teal,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(mq(context, 24)),
                  alignment: Alignment.center,
                  child: Text(
                    "Patient Sleep Pattern",
                    style: TextStyle(
                        fontSize: mq(context, 24),
                        color: Colors.teal,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(mq(context, 30)),
                  height: mq(context, 300),
                  child: LineChart(LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: bottomTitleWidgets)),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 42,
                          getTitlesWidget: leftTitleWidgets,
                        ))),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.cyanAccent),
                    ),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 12,
                    lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                  "${spot.y.toString()} hrs",
                                  const TextStyle(
                                      color: Colors.cyanAccent,
                                      fontWeight: FontWeight.bold));
                            }).toList();
                          },
                        )),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          ...futureSleepList.map((e) => FlSpot(
                                e.dayIndex.toDouble() - 1,
                                e.timeSlept.inHours.toDouble() +
                                    e.timeSlept.inMinutes.remainder(60) / 100,
                              ))
                        ],
                        isCurved: true,
                        gradient: const LinearGradient(
                          colors: [Colors.cyanAccent, Colors.teal],
                        ),
                        barWidth: 5,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.cyanAccent.withOpacity(0.5),
                              Colors.teal.withOpacity(0.5)
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                Container(
                  margin: EdgeInsets.all(mq(context, 24)),
                  alignment: Alignment.center,
                  child: Text(
                    "Patient BMI: 28",
                    style: TextStyle(
                        fontSize: mq(context, 24),
                        color: Colors.teal,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(mq(context, 24)),
                  alignment: Alignment.center,
                  child: Text(
                    "Patient Physical Activity",
                    style: TextStyle(
                        fontSize: mq(context, 24),
                        color: Colors.teal,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "1550 kcal",
                          style: TextStyle(fontSize: mq(context, 18)),
                        ),
                        Text(
                          "Calories burned",
                          style: TextStyle(
                              color: Colors.teal, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text("32000",
                            style: TextStyle(fontSize: mq(context, 18))),
                        Text("Steps",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    Column(
                      children: [
                        Text("24 km",
                            style: TextStyle(fontSize: mq(context, 18))),
                        Text("Distance",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(mq(context, 10)),
                ),
                Container(
                  margin: EdgeInsets.all(mq(context, 30)),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Medications",
                    style: TextStyle(
                        fontSize: mq(context, 30),
                        color: Colors.teal,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                if (savedMedicationList.isEmpty)
                  Container(
                    margin: EdgeInsets.all(mq(context, 20)),
                    child: Text("Add some medications"),
                  )
                else
                  Container(
                    margin: EdgeInsets.all(mq(context, 20)),
                    height: mq(context, 300),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Dismissible(
                              key: ValueKey(index),
                              background: Container(
                                color: Colors.red,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.all(mq(context, 20)),
                                        child: Icon(Icons.delete)),
                                    Container(
                                        margin: EdgeInsets.all(mq(context, 20)),
                                        child: Icon(Icons.delete))
                                  ],
                                ),
                              ),
                              child: SavedMedicationCard(
                                  medication: savedMedicationList[index]));
                        },
                        separatorBuilder: (context, index) => Container(
                              margin: EdgeInsets.all(mq(context, 20)),
                            ),
                        itemCount: savedMedicationList.length),
                  ),
                ElevatedButton(
                    onPressed: () {
                      openMedicationModal(context);
                    },
                    child: Text("Write Medication")),
                Container(
                  margin: EdgeInsets.all(mq(context, 30)),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Routines",
                    style: TextStyle(
                        fontSize: mq(context, 30),
                        color: Colors.teal,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                if (savedRoutinesList.isEmpty)
                  Container(
                    margin: EdgeInsets.all(mq(context, 20)),
                    child: Text("Add some routines"),
                  )
                else
                  Container(
                    margin: EdgeInsets.all(mq(context, 20)),
                    height: mq(context, 300),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Dismissible(
                              key: ValueKey(index),
                              background: Container(
                                color: Colors.red,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.all(mq(context, 20)),
                                        child: Icon(Icons.delete)),
                                    Container(
                                        margin: EdgeInsets.all(mq(context, 20)),
                                        child: Icon(Icons.delete))
                                  ],
                                ),
                              ),
                              child: SavedRoutineCard(
                                  routine: savedRoutinesList[index]));
                        },
                        separatorBuilder: (context, index) => Container(
                              margin: EdgeInsets.all(mq(context, 20)),
                            ),
                        itemCount: savedRoutinesList.length),
                  ),
                ElevatedButton(
                    onPressed: () {
                      openRoutineModal(context);
                    },
                    child: Text("Write Routine")),
                Container(
                  margin: EdgeInsets.all(mq(context, 30)),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Instructions",
                    style: TextStyle(
                        fontSize: mq(context, 30),
                        color: Colors.teal,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: mq(context, 30), vertical: mq(context, 10)),
                  child: TextFormField(
                    style: TextStyle(fontSize: mq(context, 21)),
                    key: const ValueKey("generalInstructions"),
                    maxLines: 6,
                    maxLength: 200,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter proper instructions";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      setState(() {
                        generalInstructions = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(mq(context, 25)))),
                      label: Text(
                        "General Instructions",
                        style: TextStyle(fontSize: mq(context, 21)),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: mq(context, 30), vertical: mq(context, 10)),
                  child: TextFormField(
                    style: TextStyle(fontSize: mq(context, 21)),
                    key: const ValueKey("dietaryRecommendations"),
                    maxLines: 6,
                    maxLength: 200,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter proper dietary recommendations";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      setState(() {
                        dietaryRecommendations = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(mq(context, 25)))),
                      label: Text(
                        "Dietary recommendations",
                        style: TextStyle(fontSize: mq(context, 21)),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: mq(context, 30), vertical: mq(context, 10)),
                  child: TextFormField(
                    style: TextStyle(fontSize: mq(context, 21)),
                    key: const ValueKey("activityRestrictions"),
                    maxLines: 6,
                    maxLength: 200,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter proper activity restrictions";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      setState(() {
                        activityRestrictions = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(mq(context, 25)))),
                      label: Text(
                        "Activity Restrictions",
                        style: TextStyle(fontSize: mq(context, 21)),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: mq(context, 30), vertical: mq(context, 10)),
                  child: TextFormField(
                    style: TextStyle(fontSize: mq(context, 21)),
                    key: const ValueKey("additionalInstructions"),
                    maxLines: 6,
                    maxLength: 200,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter proper instructions";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      setState(() {
                        additionalInstructions = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(mq(context, 25)))),
                      label: Text(
                        "Additional Instructions",
                        style: TextStyle(fontSize: mq(context, 21)),
                      ),
                    ),
                  ),
                ),
                if (!waiting)
                  Container(
                    margin: EdgeInsets.all(mq(context, 20)),
                    child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              savedMedicationList.isNotEmpty &&
                              savedMedicationList.isNotEmpty) {
                            _formKey.currentState!.save();
                            setState(() {
                              waiting = true;
                            });
                            await onPrescriptionSubmit(context);
                            setState(() {
                              waiting = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Please fill all the details")));
                          }
                        },
                        style: const ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.teal),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: mq(context, 24)),
                        )),
                  )
                else
                  Container(
                      margin: EdgeInsets.all(mq(context, 20)),
                      child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
