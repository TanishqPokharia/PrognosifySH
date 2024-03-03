import 'package:flutter/material.dart';

class RoutineForm extends StatefulWidget {
  RoutineForm({
    super.key,
    required this.index,
  });
  int index;
  String routineName = "";
  String duration = "";
  String frequency = "";
  String startTime = "";
  String endTime = "";
  final formKey = GlobalKey<FormState>();

  @override
  State<RoutineForm> createState() => _RoutineFormState();
}

class _RoutineFormState extends State<RoutineForm> {
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(mq(context, 30)),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: mq(context, 30), horizontal: mq(context, 50)),
            child: Text(
              "Routine ${widget.index + 1}",
              style: TextStyle(
                  fontSize: mq(context, 24),
                  color: Colors.teal,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq(context, 45), vertical: mq(context, 10)),
            child: TextFormField(
              style: TextStyle(fontSize: mq(context, 21)),
              key: const ValueKey("routineName"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter proper routine name";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                widget.routineName = newValue!;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(mq(context, 25)))),
                label: Text(
                  "Routine Name",
                  style: TextStyle(fontSize: mq(context, 21)),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq(context, 45), vertical: mq(context, 10)),
            child: TextFormField(
              style: TextStyle(fontSize: mq(context, 21)),
              key: const ValueKey("duration"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter proper duration";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                widget.duration = newValue!;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(mq(context, 25)))),
                label: Text(
                  "Duration",
                  style: TextStyle(fontSize: mq(context, 21)),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq(context, 45), vertical: mq(context, 10)),
            child: TextFormField(
              style: TextStyle(fontSize: mq(context, 21)),
              key: const ValueKey("frequency"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter proper frequency";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                widget.frequency = newValue!;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(mq(context, 25)))),
                label: Text(
                  "Frequency",
                  style: TextStyle(fontSize: mq(context, 21)),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq(context, 45), vertical: mq(context, 10)),
            child: TextFormField(
              style: TextStyle(fontSize: mq(context, 21)),
              key: const ValueKey("startTime"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter proper time";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                widget.startTime = newValue!;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(mq(context, 25)))),
                label: Text(
                  "Start Time",
                  style: TextStyle(fontSize: mq(context, 21)),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq(context, 45), vertical: mq(context, 10)),
            child: TextFormField(
              style: TextStyle(fontSize: mq(context, 21)),
              key: const ValueKey("endTime"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter proper time";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                widget.endTime = newValue!;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(mq(context, 25)))),
                label: Text(
                  "End Time",
                  style: TextStyle(fontSize: mq(context, 21)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
