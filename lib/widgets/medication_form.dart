import 'package:dob_input_field/dob_input_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationForm extends StatefulWidget {
  MedicationForm({super.key, required this.index});
  final int index;
  final formKey = GlobalKey<FormState>();
  String medicationName = "";
  String dosage = "";
  String frequency = "";
  String route = "";
  String startDate = "";
  String endDate = "";

  @override
  State<MedicationForm> createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
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
              "Medication ${widget.index + 1}",
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
              key: const ValueKey("medicationName"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter proper medication name";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                setState(() {
                  widget.medicationName = newValue!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(mq(context, 25)))),
                label: Text(
                  "Medication Name",
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
              key: const ValueKey("dosage"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter proper dosage";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                setState(() {
                  widget.dosage = newValue!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(mq(context, 25)))),
                label: Text(
                  "Dosage",
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
                setState(() {
                  widget.frequency = newValue!;
                });
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
              key: const ValueKey("route"),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter proper route";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                setState(() {
                  widget.route = newValue!;
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(mq(context, 25)))),
                  label: Text(
                    "Route",
                    style: TextStyle(fontSize: mq(context, 21)),
                  ),
                  hintText: "oral, injection, etc."),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq(context, 45), vertical: mq(context, 10)),
            child: DOBInputField(
              inputDecoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: mq(context, 20)),
                  hintStyle: TextStyle(fontSize: mq(context, 20)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(mq(context, 25)))),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              showLabel: true,
              showCursor: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              fieldLabelText: "Start Date",
              fieldHintText: "DD/MM/YYYY",
              onDateSubmitted: (value) {
                setState(() {
                  widget.startDate = DateFormat("dd/MM/yyyy").format(value);
                });
              },
              onDateSaved: (value) {
                setState(() {
                  widget.startDate = DateFormat("dd/MM/yyyy").format(value);
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: mq(context, 45), vertical: mq(context, 10)),
            child: DOBInputField(
              inputDecoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: mq(context, 20)),
                  hintStyle: TextStyle(fontSize: mq(context, 20)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(mq(context, 25)))),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              showLabel: true,
              showCursor: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              fieldLabelText: "End Date (if applicable)",
              fieldHintText: "DD/MM/YYYY",
              onDateSubmitted: (value) {
                setState(() {
                  widget.endDate = DateFormat("dd/MM/yyyy").format(value);
                });
              },
              onDateSaved: (value) {
                setState(() {
                  widget.endDate = DateFormat("dd/MM/yyyy").format(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
