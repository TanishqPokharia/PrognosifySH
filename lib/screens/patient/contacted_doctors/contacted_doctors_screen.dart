import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prognosify/data/doctor_data.dart';
import 'package:prognosify/models/mediaquery/mq.dart';
import 'package:prognosify/widgets/contacted_doctors_card.dart';

List<DoctorData> doctorList = [
  DoctorData(
      name: "Atharv Tiwari",
      speciality: "Cardiologist",
      fees: "700",
      qualification: "MBBS",
      token: "",
      uid: "",
      contact: "7389277839")
];

class ContactedDoctorsScreen extends ConsumerWidget {
  const ContactedDoctorsScreen({super.key});
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text("Previously Contacted Doctors")),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return ContactedDoctorsCard(doctorData: doctorList[index]);
            },
            separatorBuilder: (context, index) => SizedBox(
              height: mq(context, 10),
            ),
            itemCount: doctorList.length,
          ),
        ),
      ),
    );
  }
}
