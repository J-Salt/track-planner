import 'package:flutter/material.dart';
import 'package:track_planner/preview_workout.dart';
import 'package:track_planner/utils/reusable_appbar.dart';

class Activities extends StatelessWidget {
  const Activities({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Activities",
        context: context,
      ),
      body: ListView(
        children: [
          PreviewWorkout(),
          PreviewWorkout(),
          PreviewWorkout(),
          PreviewWorkout(),
          PreviewWorkout(),
        ],
      )
    );
  }
}
