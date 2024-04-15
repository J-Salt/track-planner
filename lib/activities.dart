import 'package:flutter/material.dart';
import 'package:track_planner/preview_workout.dart';
import 'package:track_planner/service.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/workout.dart';

class Activities extends StatelessWidget {
  const Activities({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Activities",
        context: context,
        trailingActions: [
          IconButton(
              onPressed: () async {
                Service().getFriendsWorkouts("OzsRkaJIeddj2CX2SSx0jeamGmC3");
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: Center(
        child: ListView(
          children: const <Widget>[
            // PreviewWorkout(),
          ],
        ),
      ),
    );
  }
}
