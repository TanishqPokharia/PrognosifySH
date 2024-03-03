import 'package:flutter/material.dart';
import 'package:prognosify/data/medication.dart';
import 'package:prognosify/screens/doctor/prescription_screen.dart';
import 'package:prognosify/widgets/medication_form.dart';

class MedicationPrescription extends StatefulWidget {
  const MedicationPrescription({super.key});

  @override
  State<MedicationPrescription> createState() => MedicationPrescriptionState();
}

class MedicationPrescriptionState extends State<MedicationPrescription> {
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
            child: Column(
          children: [
            if (medicationPrescriptionList.isEmpty)
              Container(
                margin: EdgeInsets.all(mq(context, 20)),
                child: Center(
                  child: Text(
                    "Add some medications",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: Colors.teal),
                  ),
                ),
              )
            else
              ...medicationPrescriptionList,
            Container(
              margin: EdgeInsets.all(mq(context, 20)),
              child: ElevatedButton(
                  onPressed: () {
                    medicationPrescriptionList.forEach((medicationForm) {
                      if (medicationForm.formKey.currentState!.validate()) {
                        medicationForm.formKey.currentState!.save();
                        setState(() {
                          savedMedicationList.add(Medication(
                              name: medicationForm.medicationName,
                              dosage: medicationForm.dosage,
                              frequency: medicationForm.frequency,
                              route: medicationForm.route,
                              startDate: medicationForm.startDate,
                              endDate: medicationForm.endDate));
                        });
                      }
                    });
                    print(savedMedicationList.length);
                    Navigator.pop(context);
                  },
                  child: Text("Submit Medication")),
            ),
            Container(
              margin: EdgeInsets.only(bottom: mq(context, 350)),
            )
          ],
        )),
        Positioned(
            bottom: mq(context, 30),
            right: mq(context, 20),
            width: mq(context, 150),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  medicationPrescriptionList.add(
                      MedicationForm(index: medicationPrescriptionList.length));
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: mq(context, 10),
                  ),
                  Text("Add")
                ],
              ),
            )),
        Positioned(
            bottom: mq(context, 120),
            right: mq(context, 20),
            width: mq(context, 150),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  medicationPrescriptionList.isEmpty
                      ? null
                      : medicationPrescriptionList.removeLast();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove),
                  SizedBox(
                    width: mq(context, 10),
                  ),
                  Text("Remove")
                ],
              ),
            ))
      ],
    );
  }
}
