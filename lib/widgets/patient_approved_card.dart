import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/data/patient_card_data.dart';
import 'package:prognosify/router/app_router_constants.dart';

class PatientApprovedCard extends StatelessWidget {
  const PatientApprovedCard({super.key, required this.patientCardData});
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
                    width: mq(context, 20),
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
                  "Additiona Notes: ${patientCardData.notes}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(mq(context, 10)),
                child: ElevatedButton(
                    style: ButtonStyle(elevation: MaterialStatePropertyAll(3)),
                    onPressed: () {
                      GoRouter.of(context).pushNamed(
                          AppRouterConstants.prescriptionScreen,
                          extra: patientCardData);
                    },
                    child: Text("Prescribe")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
