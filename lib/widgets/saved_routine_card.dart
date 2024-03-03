import 'package:flutter/material.dart';
import 'package:prognosify/data/routine.dart';

class SavedRoutineCard extends StatefulWidget {
  const SavedRoutineCard({super.key, required this.routine});
  final Routine routine;

  @override
  State<SavedRoutineCard> createState() => _SavedRoutineCardState();
}

class _SavedRoutineCardState extends State<SavedRoutineCard> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.routine.name),
      children: [
        Text(widget.routine.duration),
        Text(widget.routine.frequency),
        Text(widget.routine.startTime),
        Text(widget.routine.endTime)
      ],
    );
  }
}
