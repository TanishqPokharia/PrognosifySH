import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  onPrescriptionSubmit(context) async {
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

    var data = {
      'to': widget.patientData.token,
      'notification': {
        'title': 'Prognosfiy',
        'body':
            'Dr. ${FirebaseAuth.instance.currentUser!.displayName} has sent prescription',
        "sound": "jetsons_doorbell.mp3"
      },
      'android': {
        'notification': {
          'notification_count': 23,
        },
      },
      'data': {'type': 'msj', 'id': 'Prognosify'}
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                Container(
                  margin: EdgeInsets.all(mq(context, 20)),
                  child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            savedMedicationList.isNotEmpty &&
                            savedMedicationList.isNotEmpty) {
                          _formKey.currentState!.save();
                          onPrescriptionSubmit(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Please fill all the details")));
                        }
                      },
                      style: ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(
                              Size(mq(context, 400), mq(context, 80))),
                          foregroundColor:
                              const MaterialStatePropertyAll(Colors.white),
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.teal),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(mq(context, 10))))),
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: mq(context, 24)),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
