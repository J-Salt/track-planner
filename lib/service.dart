import 'package:firebase_database/firebase_database.dart';

/// Service class with functions for editing firebase entities
class Service {
  late DatabaseReference db;

  /// Creates user with [id] and [user].
  void createUser(String id, user) async {
    db = FirebaseDatabase.instance.ref("users/$id");
    await db
        .set(user)
        .then((_) => print("success!"))
        .catchError((err) => {print(err)});
  }

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
}
