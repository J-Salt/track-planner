import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:track_planner/utils/weather_info.dart';
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

  Future<List<Map<String, dynamic>>> getAthletesForAssignment(
      String uid) async {
    db = FirebaseDatabase.instance.ref("users");
    DatabaseEvent snapshot =
        await db.orderByChild("isCoach").equalTo(false).once();

    List<Map<String, dynamic>> out = [];
    if (snapshot.snapshot.value == null) return [];
    Map<Object?, Object?> temp =
        snapshot.snapshot.value as Map<Object?, Object?>;
    Map<String, dynamic> tempMap = {};
    temp.forEach((key, value) {
      if (key != uid) {
        tempMap = {
          "id": key,
          "name": (value as Map)["name"] ?? "",
          "gradYear": value["gradYear"] ?? 0,
          "eventGroup": value["eventGroup"] ?? "",
          "isCoach": value["isCoach"],
          "selected": false,
        };
        out.add(tempMap);
      }
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
    finalWorkout["completed"] = false;
    finalWorkout["date"] = date.toString();

    //assign the workout to athletes
    for (String userId in assignedAthletes) {
      db = FirebaseDatabase.instance.ref("users/$userId/workouts/$uuid");
      db.set(finalWorkout);
    }
  }

  void addFriends(String uid, List<String> friendIds) async {
    db = FirebaseDatabase.instance.ref("users/$uid/friends");
    DataSnapshot snapshot = await db.get();
    if (snapshot.value != null) {
      List<dynamic> currentFriends = snapshot.value as List<dynamic>;
      for (dynamic id in currentFriends) {
        if (!friendIds.contains(id)) {
          friendIds.add(id);
        }
      }
    }
    db = FirebaseDatabase.instance.ref("users/$uid/friends");
    await db.set(friendIds);
  }

  Future<void> logWorkout(
      String uid, String workoutId, List<Set> sets, WeatherInfo weather) async {
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
    db = FirebaseDatabase.instance
        .ref("users/$uid/workouts/$workoutId/completed");
    db.set(true); //complete the workout
    db =
        FirebaseDatabase.instance.ref("users/$uid/workouts/$workoutId/weather");
    Map<String, dynamic> weatherMap = {
      "weather": weather.weather,
      "temp": weather.temp,
    };
    await db.update(weatherMap);
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

  Future<List<DisplayWorkout>> getFriendsWorkouts(String uid) async {
    List<DisplayWorkout> workouts = [];

    db = FirebaseDatabase.instance.ref("users/$uid/friends");
    DataSnapshot friendIdsSnapshot = await db.get();
    if (friendIdsSnapshot.value == null) return [];
    List<Object?> friendsIds = friendIdsSnapshot.value as List<Object?>;
    for (Object? id in friendsIds) {
      String strId = id.toString();
      db = FirebaseDatabase.instance.ref();
      DataSnapshot snapshot = await db
          .child('users')
          .child(strId)
          .orderByChild('workouts')
          .limitToFirst(10) // Limit the number of workouts
          .get();
      if (snapshot.value == null) continue;
      final Map<Object?, Object?> userMap =
          snapshot.value as Map<Object?, Object?>;
      if (userMap['workouts'] != null) {
        String name = userMap['name'].toString();
        Map<dynamic, dynamic> friendWorkouts = userMap['workouts'] as Map;

        for (MapEntry<dynamic, dynamic> workout in friendWorkouts.entries) {
          if (workout.value['completed'] == null ||
              workout.value['completed'] == false) {
            continue;
          }
          dynamic sets = workout.value["sets"];
          String weather = "";
          String temp = "";
          if (workout.value['weather'] != null) {
            weather = (workout.value['weather'] as Map)['weather'].toString();
            temp = (workout.value['weather'] as Map)['temp'].toString();
          }

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

          DateTime date = DateTime.parse(workout.value["date"].toString());

          date = DateTime(date.year, date.month, date.day)
              .toUtc()
              .subtract(Duration(hours: 4));

          workouts.add(DisplayWorkout(
              id: workout.key.toString(),
              date: date,
              sets: tempSets,
              name: name,
              weather: weather,
              temp: temp));
        }
      }
    }
    workouts.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    return workouts.reversed.toList();
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
}
