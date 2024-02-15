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

  // TODO persist sets and add the id's to the parent activity
  void createActivity(String title, String desc, List<Object> sets) async {
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
