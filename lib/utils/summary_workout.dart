import 'dart:ui';

import 'package:flutter/material.dart';
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
          Text(
            'Workout Summary',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          // details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Distance:'),
              Text(
                '${workout.totalDistance} Meters',
                style: TextStyle(
                  fontSize: 20
                )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Time:'),
              Text(
                '${workout.totalTime.inMinutes.toString()} minutes',
                style: TextStyle(
                  fontSize: 20
                )
              ),
            ],
          ),
          Text('Notes:'),
          Text(
            workout.notes,
            style: TextStyle(
              fontSize: 20
            ),
            textAlign: TextAlign.right,
          ),
          Text('Date: ' + workout.date.toIso8601String()),
          Text('Athlete Name: ' + workout.name)       
        ],
      ),
    );
  }
}
