import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_planner/auth.dart';
import 'package:track_planner/preview_workout.dart';
import 'package:track_planner/service.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/workout.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

//TODO workouts in reverse cronological order from how they should be. i.e. most recent first.
class _ActivitiesState extends State<Activities> {
  late Future<List<DisplayWorkout>> _friends_activites;
  static List<PreviewWorkout> workouts = [];

  final User user = Auth().currentUser!;
  void getWorkouts() async {
    _friends_activites = Service().getFriendsWorkouts(user.uid);
  }

  @override
  void initState() {
    getWorkouts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ReusableAppBar(
          pageTitle: "Activities",
          context: context,
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
                  List<DisplayWorkout> friends_activites =
                      snapshot.data as List<DisplayWorkout>;
                  workouts = [];
                  for (DisplayWorkout activity in friends_activites) {
                    workouts.add(PreviewWorkout(workout: activity));
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: workouts,
                  );
                }
                ;
              }),
        ));
  }
}
