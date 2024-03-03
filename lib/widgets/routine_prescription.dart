import 'package:flutter/material.dart';
import 'package:prognosify/data/routine.dart';
import 'package:prognosify/screens/doctor/prescription_screen.dart';
import 'package:prognosify/widgets/routine_form.dart';

class RoutinePrescription extends StatefulWidget {
  const RoutinePrescription({super.key});

  @override
  State<RoutinePrescription> createState() => _RoutinePrescriptionState();
}

class _RoutinePrescriptionState extends State<RoutinePrescription> {
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
            if (routinePrescriptionList.isEmpty)
              Container(
                margin: EdgeInsets.all(mq(context, 20)),
                child: Center(
                  child: Text(
                    "Add some routines",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: Colors.teal),
                  ),
                ),
              )
            else
              ...routinePrescriptionList,
            Container(
              margin: EdgeInsets.all(mq(context, 20)),
              child: ElevatedButton(
                  onPressed: () {
                    routinePrescriptionList.forEach((routineForm) {
                      if (routineForm.formKey.currentState!.validate()) {
                        routineForm.formKey.currentState!.save();
                        setState(() {
                          savedRoutinesList.add(Routine(
                              name: routineForm.routineName,
                              duration: routineForm.duration,
                              frequency: routineForm.frequency,
                              startTime: routineForm.startTime,
                              endTime: routineForm.endTime));
                        });
                      }
                    });
                    print(savedRoutinesList.length);
                    Navigator.pop(context);
                  },
                  child: Text("Submit Routine")),
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
                  routinePrescriptionList.add(RoutineForm(
                    index: routinePrescriptionList.length,
                  ));
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
                  routinePrescriptionList.isEmpty
                      ? null
                      : routinePrescriptionList.removeLast();
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
