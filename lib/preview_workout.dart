import 'package:flutter/material.dart';
import 'package:track_planner/view_workout.dart';

class PreviewWorkout extends StatelessWidget {
  const PreviewWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewWorkout())),
        child: Container(
          height: 200,
          color: Theme.of(context).colorScheme.inversePrimary,
          child: const Center(
            child: Text(
              'Preview Workout'
           ),
          )
        ),
      )
    );
  }
}