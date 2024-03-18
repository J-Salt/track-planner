import 'package:flutter/material.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/set_summary.dart';
import 'package:track_planner/utils/summary_workout.dart';

class ViewWorkout extends StatelessWidget {
  const ViewWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "View Workout",
        context: context,
      ),
      body: ListView(
        children: [
          WorkoutSummary(
            totalDistance: '0 mi', 
            time: '0:00', 
            notes: 'N/A', 
            onPressed: (){}
          ),
          SetSummary(onPressed: (){}),
          SetSummary(onPressed: (){}),
        ],
      )
    );
  }
}