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

  Future<List<Map<String, dynamic>>> getAthletesForAssignment() async {
    db = FirebaseDatabase.instance.ref("users");
    DatabaseEvent snapshot =
        await db.orderByChild("isCoach").equalTo(false).once();

    List<Map<String, dynamic>> out = [];
    Map<Object?, Object?> temp =
        snapshot.snapshot.value as Map<Object?, Object?>;
    Map<String, dynamic> tempMap = {};
    temp.forEach((key, value) {
      Map<Object?, Object?> t = value as Map<Object?, Object?>;
      tempMap = {
        "id": key,
        "name": value["name"] ?? "",
        "gradYear": value["gradYear"] ?? 0,
        "eventGroup": value["eventGroup"] ?? "",
        "isCoach": value["isCoach"],
        "selected": false,
      };
      out.add(tempMap);
    });
    return out;
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
        currentRep["repRunTimes"] = [];
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

  Future<void> logWorkout(String uid, String workoutId, List<Set> sets) async {
    db = FirebaseDatabase.instance.ref("users/$uid/workouts/$workoutId/sets");

    List<Object> tempSets = [];

    for (int set = 0; set < sets.length; set++) {
      Map<String, Object> currentSet = {};
      List<Object> tempReps = [];
      for (int rep = 0; rep < sets[set].reps.length; rep++) {
        Map<String, Object> currentRep = {};
        currentRep["distance"] = sets[set].reps[rep].distance;
        currentRep["numReps"] = sets[set].reps[rep].numReps;
        currentRep["repRest"] = sets[set].reps[rep].repRest.toString();
        currentRep["repTime"] = sets[set].reps[rep].repTime.toString();
        List<String> repRunTimes = [];
        if (sets[set].reps[rep].repRunTimes != null) {
          for (Duration runTime in sets[set].reps[rep].repRunTimes!) {
            repRunTimes.add(runTime.toString());
          }
        }
        currentRep["repRunTimes"] = repRunTimes;

        tempReps.add(currentRep);
      }
      currentSet["reps"] = tempReps;
      currentSet["setRest"] = sets[set].setRest.toString();
      tempSets.add(currentSet);
    }

    await db.set(tempSets);
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
      for (Map<Object?, Object?> set in sets) {
        List<Rep> tempReps = [];
        Duration setRest = parseDuration(set["setRest"].toString());
        dynamic reps = set["reps"] ?? [];

        for (Map<Object?, Object?> rep in reps) {
          List<Duration> tempRepRunTimes = [];
          if (rep["repRunTimes"] != null) {
            for (Object? time in (rep["repRunTimes"] as List<Object?>)) {
              tempRepRunTimes.add(parseDuration2(time.toString()));
            }
          } else {
            tempRepRunTimes = [];
          }
          tempReps.add(
            Rep(
              distance: rep["distance"].toString(),
              numReps: rep["numReps"].toString(),
              repRest: parseDuration(rep["repRest"].toString()),
              repTime: parseDuration(rep["repTime"].toString()),
              repRunTimes: tempRepRunTimes,
            ),
          );
        }
        tempSets.add(Set(reps: tempReps, setRest: setRest));
      }

      DateTime date = DateTime.parse(workout["date"].toString());

      date = DateTime(date.year, date.month, date.day)
          .toUtc()
          .subtract(Duration(hours: 4));

      if (workouts.containsKey(date)) {
        workouts[date]
            ?.add(Workout(id: key.toString(), date: date, sets: tempSets));
      } else {
        workouts[date] = [
          Workout(id: key.toString(), date: date, sets: tempSets)
        ];
      }
    });

    return workouts;
  }

  Duration parseDuration(String s) {
    List<String> timeParts = s.split(':');
    if (s == "null" || s == "" || null == s) return Duration.zero;

    List<String> secondParts = timeParts[2].split(".");
    return Duration(
        hours: int.parse(timeParts[0]),
        minutes: int.parse(timeParts[1]),
        seconds: int.parse(secondParts[0]));
  }

  Duration parseDuration2(String s) {
    List<String> timeParts = s.split(':');
    if (s == "null" || s == "" || null == s) return Duration.zero;

    List<String> secondParts = timeParts.last.split(".");
    if (secondParts.length == 1) {
      secondParts.add("0"); //add a zero for milliseconds
    }
    if (timeParts.length == 1) {
      //only seconds
      Duration temp = Duration(
          seconds: int.tryParse(secondParts[0]) ?? 0,
          milliseconds: int.tryParse("${secondParts[1]}0") ?? 0);
      return temp;
    } else if (timeParts.length == 2) {
      //seconds and minutes
      Duration temp = Duration(
          minutes: int.tryParse(timeParts[0]) ?? 0,
          seconds: int.tryParse(secondParts[0]) ?? 0,
          milliseconds: int.tryParse("${secondParts[1]}0") ?? 0);
      return temp;
    } else if (timeParts.length == 3) {
      //hours seconds minutes
      Duration temp = Duration(
          hours: int.tryParse(timeParts[0]) ?? 0,
          minutes: int.tryParse(timeParts[1]) ?? 0,
          seconds: int.tryParse(secondParts[0]) ?? 0,
          milliseconds: int.tryParse("${secondParts[1]}0") ?? 0);
      return temp;
    } else {
      return Duration.zero;
    }
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
