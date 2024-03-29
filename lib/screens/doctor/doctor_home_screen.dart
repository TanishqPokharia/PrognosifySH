import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prognosify/data/patient_card_data.dart';
import 'package:prognosify/widgets/patient_request_card.dart';

final patientListProvider = StreamProvider<List<dynamic>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  final Stream<List<dynamic>> stream = FirebaseFirestore.instance
      .collection("doctors")
      .doc(user!.uid)
      .snapshots()
      .map((event) => event.data()?['patientRequests']);

  return stream;
});

class DoctorHomeScreen extends ConsumerWidget {
  DoctorHomeScreen({super.key});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientRequestList = ref.watch(patientListProvider);
    return Container(
      padding: EdgeInsets.all(mq(context, 15)),
      height: MediaQuery.of(context).size.height,
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
                      "Greetings,",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: mq(context, 36),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "Dr. ${FirebaseAuth.instance.currentUser!.displayName ?? "User"}",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: mq(context, 36),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(
                      height: mq(context, 20),
                    ),
                    Container(
                      margin: EdgeInsets.all(mq(context, 20)),
                      alignment: Alignment.center,
                      child: Text(
                        "Patient Queue",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: mq(context, 36),
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    patientRequestList.when(
                      loading: () => Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) {
                        print(error);
                        return Center(child: Text("Something Went Wrong"));
                      },
                      data: (data) {
                        return Column(
                          children: [
                            if (data.isNotEmpty)
                              ...data.map((patient) {
                                return PatientRequestCard(
                                    patientCardData: PatientCardData(
                                        name: patient!['name'],
                                        age: patient['age'],
                                        gender: patient['gender'],
                                        bmi: patient['bmi'].toStringAsFixed(2),
                                        disease: "",
                                        notes: patient['notes'],
                                        email: patient['email'],
                                        token: patient['token']));
                              })
                            else
                              Center(
                                child: Text(
                                  "No patients at the moment",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
