import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:prognosify/data/doctor_data.dart';

class ContactedDoctorsCard extends StatelessWidget {
  final DoctorData doctorData;

  const ContactedDoctorsCard({super.key, required this.doctorData});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(mq(context, 20)),
      height: mq(context, 120),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.all(mq(context, 10)),
              child: CircleAvatar(
                radius: mq(context, 40),
                backgroundImage: AssetImage("assets/Doctordefault.jpeg"),
              ),
            ),
            SizedBox(
              width: mq(context, 210),
              height: mq(context, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: SizedBox(
                      child: Text(
                        "Dr. ${doctorData.name}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    doctorData.speciality,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    doctorData.qualification,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      final canCall = await FlutterPhoneDirectCaller.callNumber(
                          doctorData.contact);

                      if (!canCall!) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Could not make call")));
                        }
                      }
                    },
                    icon: Icon(Icons.call))
              ],
            )
          ],
        ),
      ),
    );
  }
}
