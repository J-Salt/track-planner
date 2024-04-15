import 'package:flutter/material.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/set_summary.dart';
import 'package:track_planner/utils/summary_workout.dart';
import 'package:track_planner/utils/workout.dart';

class ViewWorkout extends StatelessWidget {
  const ViewWorkout({super.key, required this.workout});
  final Workout workout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "View Workout",
        context: context,
      ),
      body: Column(
        children: [
          WorkoutSummary(workout: workout),
          ListView.builder(
            itemCount: workout.sets.length,
            itemBuilder: (BuildContext context, int index) {
              SetSummary(set: workout.sets[index], setNumber: index + 1);
            },
          )
        ],
      )
    );
  }
}