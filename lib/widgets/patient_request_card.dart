import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prognosify/data/patient_card_data.dart';

class PatientRequestCard extends StatelessWidget {
  const PatientRequestCard({super.key, required this.patientCardData});
  final PatientCardData patientCardData;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: mq(context, 10)),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mq(context, 20))),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(mq(context, 20)),
                    child: CircleAvatar(
                      foregroundImage: AssetImage('assets/Default.svg'),
                      radius: mq(context, 50),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(mq(context, 10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.all(mq(context, 5)),
                            child: Text("Name: ${patientCardData.name}")),
                        Container(
                            margin: EdgeInsets.all(mq(context, 5)),
                            child: Text("Age: ${patientCardData.age}")),
                        Container(
                            margin: EdgeInsets.all(mq(context, 5)),
                            child: Text("Gender: ${patientCardData.gender}")),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.all(mq(context, 20)),
                width: mq(context, 500),
                child: Text(
                  textAlign: TextAlign.start,
                  "Additional Notes: ${patientCardData.notes}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(mq(context, 10)),
                child: ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStatePropertyAll(3)),
                    onPressed: () async {
                      await approvePatient();
                    },
                    child: Text("Approve")),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> approvePatient() async {
    final user = FirebaseAuth.instance.currentUser;

    // add to approved List
    final snapshot = await FirebaseFirestore.instance
        .collection("doctors")
        .doc(user!.uid)
        .get();
    final List approvedList = snapshot.data()!['approvedPatients'];

    approvedList.add({
      "age": patientCardData.age,
      "disease": patientCardData.disease,
      "email": patientCardData.email,
      "gender": patientCardData.gender,
      "name": patientCardData.name,
      "notes": patientCardData.notes,
      "token": patientCardData.token,
      "bmi": patientCardData.bmi
    });

    await FirebaseFirestore.instance
        .collection("doctors")
        .doc(user.uid)
        .update({"approvedPatients": approvedList});

    //remove from patient queue

    final List patientRequests = snapshot.data()!['patientRequests'];
    patientRequests
        .removeWhere((element) => element['email'] == patientCardData.email);

    await FirebaseFirestore.instance
        .collection("doctors")
        .doc(user.uid)
        .update({"patientRequests": patientRequests});
  }
}
