import 'package:flutter/material.dart';
import 'package:track_planner/preview_workout.dart';
import 'package:track_planner/service.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/workout.dart';

class Activities extends StatelessWidget {
  static List<DisplayWorkout> friends_activites = [];
  static List<PreviewWorkout> workouts = [];
  Activities({super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<DisplayWorkout>> _friends_activites = Service().getFriendsWorkouts("OzsRkaJIeddj2CX2SSx0jeamGmC3");
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Activities",
        context: context,
        trailingActions: [
          IconButton(
              onPressed: () async {
                _friends_activites = Service().getFriendsWorkouts("OzsRkaJIeddj2CX2SSx0jeamGmC3");
              },
              icon: Icon(Icons.person))
        ],
      ),
      body: Expanded(
        child: FutureBuilder(
          future: _friends_activites,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading data"),
              );
            } else {
              friends_activites = snapshot.data!;
              for (DisplayWorkout activity in friends_activites) {
                workouts.add(PreviewWorkout(workout: activity));
              }
              return Column(
                  children: workouts
              );
            };
          }
        ),
      )
    );
  }
}
