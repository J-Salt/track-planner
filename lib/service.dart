import 'package:firebase_database/firebase_database.dart';

/// Service class with functions for editing firebase entities
class Service {
  final DatabaseReference db = FirebaseDatabase.instance.ref();

  void createUser(int id, user) async {
    await db
        .set(user)
        .then((_) => print("success!"))
        .catchError((err) => {print(err)});
  }
}
