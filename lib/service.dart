import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:track_planner/utils/workout.dart';
import 'package:uuid/uuid.dart';

/// Service class with functions for editing firebase entities
class Service {
  late DatabaseReference db;

  /// Creates firebase entry for user with [uid] from the users authentication.
  void registerUser(
      String uid, String name, String group, int gradYear, bool isCoach) async {
    db = FirebaseDatabase.instance.ref("users/$uid");
    await db
        .set({
          "name": name,
          "eventGroup": group,
          "gradYear": gradYear,
          "isCoach": isCoach,
          "activities": [],
        })
        .then((_) => print("success!"))
        .catchError((err) => {print(err)});
  }

  Future<Map<Object?, Object?>> getUser(String uid) async {
    db = FirebaseDatabase.instance.ref("users/$uid");

    DataSnapshot snapshot = await db.get();
    return snapshot.value as Map<Object?, Object?>;
  }

  void createWorkout(List<List<Map<String, String>>> workout,
      List<Duration> setRests, List<String> assignedAthletes, DateTime date) {
    String uuid = const Uuid().v4();

    //Prepare the workout object
    List<Object> tempSets = [];

    Map<String, Object> finalWorkout = {"sets": []};
    for (int set = 0; set < workout.length; set++) {
      Map<String, Object> currentSet = {};
      List<Object> tempReps = [];
      for (int rep = 0; rep < workout[set].length; rep++) {
        Map<String, Object> currentRep = {};
        currentRep["distance"] = workout[set][rep]["distance"]!;
        currentRep["numReps"] = workout[set][rep]["numReps"]!;
        currentRep["repRest"] = workout[set][rep]["repRest"]!;
        currentRep["repTime"] = workout[set][rep]["repTime"]!;
        tempReps.add(currentRep);
      }
      currentSet["reps"] = tempReps;
      currentSet["setRest"] = setRests[set].toString();
      tempSets.add(currentSet);
    }
    finalWorkout["sets"] = tempSets;
    finalWorkout["date"] = date.toString();

    //assign the workout to athletes
    for (String userId in assignedAthletes) {
      db = FirebaseDatabase.instance.ref("users/$userId/workouts/$uuid");
      db.set(finalWorkout);
    }
  }

  Future<Map<DateTime, List<Workout>>> getWorkouts(String uid) async {
    Map<DateTime, List<Workout>> workouts = {};
    db = FirebaseDatabase.instance.ref("users/$uid/workouts");
    DataSnapshot snapshot = await db.orderByChild('date').get();
    if (snapshot.value == null) return {};
    final Map<Object?, Object?> data = snapshot.value as Map<Object?, Object?>;
    data.forEach((key, workout) {
      dynamic sets = (workout as Map<Object?, Object?>)["sets"];
      List<Set> tempSets = [];
      List<Rep> tempReps = [];
      for (Map<Object?, Object?> set in sets) {
        Duration setRest = parseDuration(set["setRest"].toString());
        dynamic reps = set["reps"];

        for (Map<Object?, Object?> rep in reps) {
          tempReps.add(Rep(
              distance: rep["distance"].toString(),
              numReps: rep["numReps"].toString(),
              repRest: parseDuration(rep["repRest"].toString()),
              repTime: parseDuration(rep["repTime"].toString())));
        }
        tempSets.add(Set(reps: tempReps, setRest: setRest));
      }

      DateTime date = DateTime.parse(workout["date"].toString());

      date = DateTime(date.year, date.month, date.day)
          .toUtc()
          .subtract(Duration(hours: 4));

      if (workouts.containsKey(date)) {
        workouts[date]?.add(Workout(date: date, sets: tempSets));
      } else {
        workouts[date] = [Workout(date: date, sets: tempSets)];
      }
    });

    return workouts;
  }

  Duration parseDuration(String s) {
    List<String> timeParts = s.split(':');
    if (s == "null" || null == s) return Duration(seconds: 0);

    List<String> secondParts = timeParts[2].split(".");
    return Duration(
        hours: int.parse(timeParts[0]),
        minutes: int.parse(timeParts[1]),
        seconds: int.parse(secondParts[0]));
  }

  // TODO add all fields
  void logActivity(String title, String desc, List<Object> sets) async {
    var uuid = const Uuid();
    List<String> setIds = [];

    for (Object set in sets) {
      String id = uuid.v4();
      db = FirebaseDatabase.instance.ref("sets/$id");
      await db.set(set);
      setIds.add(id);
    }

    db = FirebaseDatabase.instance.ref("activities/${uuid.v4()}");

    await db.set({"title": title, "description": desc, "sets": setIds});
  }
}
