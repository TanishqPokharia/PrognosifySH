import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prognosify/data/doctor_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:prognosify/data/doctor_speciality_list.dart';

final doctorListProvider = FutureProvider<List<DoctorData>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection("doctors").get();
  List<DoctorData> doctorList = [];
  print("Snapshot: $snapshot");
  snapshot.docs.forEach((element) {
    doctorList.add(DoctorData(
        name: element['name'],
        speciality: element['speciality'],
        fees: element['fees'],
        qualification: element['qualification'],
        token: element['token'],
        uid: element['uid'],
        contact: element['contact']));
  });
  print("Doctor  List : $doctorList");
  return doctorList;
});

final specialityFilterProvider =
    StateNotifierProvider((ref) => SpecialityFilterNotifier());

class SpecialityFilterNotifier extends StateNotifier<String> {
  SpecialityFilterNotifier() : super("All");

  void setSpeciality(String speciality) {
    state = speciality;
  }
}

class DoctorSearchScreen extends ConsumerStatefulWidget {
  const DoctorSearchScreen({super.key});

  @override
  ConsumerState<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends ConsumerState<DoctorSearchScreen> {
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    final doctorList = ref.watch(doctorListProvider);

    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: mq(context, 100),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...specialityList.map((e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          e.color = Colors.green;
                          specialityList.forEach((element) {
                            if (element.speciality != e.speciality) {
                              setState(() {
                                element.color = Colors.grey;
                              });
                            }
                          });
                        });
                        ref
                            .read(specialityFilterProvider.notifier)
                            .setSpeciality(e.speciality);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: e.color,
                            borderRadius:
                                BorderRadius.circular(mq(context, 10))),
                        margin: EdgeInsets.all(mq(context, 10)),
                        padding: EdgeInsets.all(mq(context, 10)),
                        child: Text(e.speciality),
                      ),
                    ))
              ],
            ),
          ),
          doctorList.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) {
              print(stackTrace);
              return Text("Error occured while fetching doctors");
            },
            data: (data) {
              List<DoctorData> filteredDoctors;
              if (ref.read(specialityFilterProvider.notifier).state == "All") {
                filteredDoctors = data;
              } else {
                filteredDoctors = data
                    .where((element) =>
                        element.speciality ==
                        ref.read(specialityFilterProvider.notifier).state)
                    .toList();
              }
              return Container(
                margin: EdgeInsets.all(mq(context, 20)),
                height: mq(context, 650),
                child: ListView.separated(
                  itemCount: filteredDoctors.length,
                  separatorBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(10),
                  ),
                  itemBuilder: (context, index) {
                    return doctorCard(context, filteredDoctors[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    ));
  }

  Container doctorCard(BuildContext context, DoctorData doctor) {
    return Container(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mq(context, 10))),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(mq(context, 20)),
                  child: CircleAvatar(
                    radius: mq(context, 50),
                    backgroundImage: AssetImage("assets/Doctordefault.jpeg"),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(mq(context, 5)),
                      child: Text("Name: ${doctor.name}"),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 5)),
                      child: Text("Speciality: ${doctor.speciality}"),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 5)),
                      child: Text("Fees: ${doctor.fees}"),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 5)),
                      child: Text("Qualification: ${doctor.qualification}"),
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(mq(context, 10)),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final snapshot = await FirebaseFirestore.instance
                      .collection("doctors")
                      .doc(doctor.uid)
                      .get();
                  final List patientsList = snapshot.data()!['patientRequests'];

                  final user = FirebaseAuth.instance.currentUser;
                  final patientSnapshot = await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user!.uid)
                      .get();

                  patientsList.add({
                    "name": patientSnapshot.data()!['name'],
                    "age": patientSnapshot.data()!['age'].toString(),
                    "gender": patientSnapshot.data()!['gender'],
                    "token": patientSnapshot.data()!['token'],
                    "email": patientSnapshot.data()!['email'],
                    "notes": "Pain"
                  });

                  await FirebaseFirestore.instance
                      .collection("doctors")
                      .doc(doctor.uid)
                      .update({"patientRequests": patientsList});

                  //send notification to the doctor
                  var data = {
                    'to': doctor.token,
                    'notification': {
                      'title': 'Prognosfiy',
                      'body': 'Appointment request received',
                      "sound": "jetsons_doorbell.mp3"
                    },
                    "android": {
                      "notification": {"channel_id": "PrognosifyChannelID"}
                    },
                  };

                  await http.post(
                      Uri.parse('https://fcm.googleapis.com/fcm/send'),
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

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    "Consultation Request sent to Dr. ${doctor.name}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )));
                },
                style:
                    const ButtonStyle(elevation: MaterialStatePropertyAll(5)),
                child: const Text("Consult"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
