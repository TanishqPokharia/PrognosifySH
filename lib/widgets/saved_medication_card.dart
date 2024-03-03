import 'package:flutter/material.dart';
import 'package:prognosify/data/medication.dart';

class SavedMedicationCard extends StatefulWidget {
  const SavedMedicationCard({super.key, required this.medication});
  final Medication medication;

  @override
  State<SavedMedicationCard> createState() => _SavedMedicationCardState();
}

class _SavedMedicationCardState extends State<SavedMedicationCard> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.medication.name),
      children: [
        Text("Dosage: ${widget.medication.dosage}"),
        Text("Frequency: ${widget.medication.frequency}"),
        Text("Route: ${widget.medication.route}"),
        Text("Start Date: ${widget.medication.startDate}"),
        Text("End Date: ${widget.medication.endDate}")
      ],
    );
  }
}
