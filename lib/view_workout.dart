import 'package:flutter/material.dart';
import 'package:track_planner/utils/reusable_appbar.dart';

class ViewWorkout extends StatelessWidget {
  const ViewWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "View Workout",
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'VIEW WORKOUT PAGE',
            ),
          ],
        ),
      ),
    );
  }
}