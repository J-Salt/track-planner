import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_planner/utils/workout.dart';
import 'package:track_planner/service.dart';

class WorkoutSummary extends StatelessWidget {
  const WorkoutSummary({super.key, required this.workout});
  final DisplayWorkout workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // summary and edit button
          const Text(
            'Workout Summary',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          // details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Distance:'),
              Text('${workout.totalDistance} Meters',
                  style: const TextStyle(fontSize: 20)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Time:'),
              Text('${workout.totalTime.inMinutes.toString()} minutes',
                  style: const TextStyle(fontSize: 20)),
            ],
          ),
          const Text('Notes:'),
          Text(
            workout.notes,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          ),
          Text('Date: ${DateFormat.yMMMMd().format(workout.date)}'),
          Text('Athlete Name: ${workout.name}')
        ],
      ),
    );
  }
}
