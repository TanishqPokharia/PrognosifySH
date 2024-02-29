import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final doctorProfileProvider =
    FutureProvider<Map<String, dynamic>?>((ref) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  final snapshot = await FirebaseFirestore.instance
      .collection("doctors")
      .doc(currentUser!.uid)
      .get();
  return snapshot.data();
});

class DoctorProfileScreen extends ConsumerWidget {
  const DoctorProfileScreen({super.key});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorProfileData = ref.watch(doctorProfileProvider);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(mq(context, 20)),
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                radius: mq(context, 100),
                child: CircleAvatar(
                  foregroundImage: const AssetImage("assets/Doctordefault.jpeg"),
                  radius: mq(context, 90),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(mq(context, 20)),
              child: Text(
                "Profile",
                style: TextStyle(
                    fontSize: mq(context, 40),
                    color: Colors.teal,
                    fontWeight: FontWeight.bold),
              ),
            ),
            doctorProfileData.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => const Text("Something Went Wrong"),
              data: (data) {
                return Container(
                  margin: EdgeInsets.all(mq(context, 20)),
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(mq(context, 20)),
                          child: Text("Name: ${data!['name']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(mq(context, 20)),
                          child: Text("Speciality: ${data['speciality']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(mq(context, 20)),
                          child: Text("Date of Birth: ${data['dob']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(mq(context, 20)),
                          child: Text(
                              "Registration Number: ${data['registrationNumber']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(mq(context, 20)),
                          child: Text(
                              "Date of Registration: ${data['registrationDate']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(mq(context, 20)),
                          child: Text(
                              "Medical Council: ${data['medicalCouncil']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(mq(context, 20)),
                          child:
                              Text("Qualification: ${data['qualification']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(mq(context, 20)),
                          child: Text(
                              "Qualification Date: ${data['qualificationDate']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(mq(context, 20)),
                          child: Text("University: ${data['universityName']}"),
                        ),
                        Container(
                          margin: EdgeInsets.all(mq(context, 20)),
                          child: Text("Aadhar Number: ${data['aadharNumber']}"),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              margin: EdgeInsets.all(mq(context, 20)),
              width: mq(context, 200),
              child: ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Logout"),
                      SizedBox(
                        width: mq(context, 10),
                      ),
                      const Icon(Icons.logout)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
