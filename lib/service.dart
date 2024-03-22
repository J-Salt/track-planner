import 'package:firebase_database/firebase_database.dart';
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

  Future<List<DateTime>> getDaysWithWorkouts(String uid) async {
    List<DateTime> dates = [];
    db = FirebaseDatabase.instance.ref("users/$uid/workouts");
    DataSnapshot snapshot = await db.orderByChild('date').get();
    if (snapshot.exists) {
      Map<Object?, Object?> workouts = snapshot.value as Map<Object?, Object?>;
      for (MapEntry workout in workouts.entries) {
        DateTime date = DateTime.parse(workout.value["date"].toString());
        dates.add(date);
      }
    }
    return dates;
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
