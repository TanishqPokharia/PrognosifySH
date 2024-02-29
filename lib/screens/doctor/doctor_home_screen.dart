import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prognosify/data/patient_card_data.dart';
import 'package:prognosify/widgets/patient_request_card.dart';

final patientRequestListProvider =
    FutureProvider<List<Map<String, dynamic>?>>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  final snapshot = await FirebaseFirestore.instance
      .collection("doctors")
      .doc(user!.uid)
      .get();
  return snapshot.data()!['patientRequests'];
});

class DoctorHomeScreen extends ConsumerWidget {
  DoctorHomeScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientRequestList = ref.watch(patientRequestListProvider);
    return Container(
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
                      "Greetings,",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: mq(context, 36),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "Dr. ${user!.displayName ?? "User"}",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: mq(context, 36),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    patientRequestList.when(
                      loading: () => CircularProgressIndicator(),
                      error: (error, stackTrace) =>
                          Text("Something Went Wrong"),
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
                                        disease: patient['disease'],
                                        notes: patient['notes'],
                                        email: patient['email'],
                                        token: patient['token']));
                              })
                            else
                              Container(
                                child: Text("No patients at the moment"),
                              )
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
