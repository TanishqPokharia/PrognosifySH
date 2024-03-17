import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:prognosify/data/doctor_data.dart';
import 'package:prognosify/models/mediaquery/mq.dart';

class ContactedDoctorsCard extends StatelessWidget {
  final DoctorData doctorData;

  const ContactedDoctorsCard({super.key, required this.doctorData});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(MQ.size(context, 20)),
      height: MQ.size(context, 120),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.all(MQ.size(context, 10)),
              child: CircleAvatar(
                radius: MQ.size(context, 40),
                backgroundImage: AssetImage("assets/Doctordefault.jpeg"),
              ),
            ),
            SizedBox(
              width: MQ.size(context, 210),
              height: MQ.size(context, 100),
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
