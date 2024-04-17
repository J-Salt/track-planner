import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_planner/auth.dart';
import 'package:track_planner/login.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/user_text_box.dart';
import 'package:track_planner/service.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});
  
  
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  Service service = Service();
  late final ValueNotifier<List<Map<String, dynamic>>> _friends;
  bool donePressed = false;
  String name = '';
  String gradYear = '';
  String eventGroup = '';

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //edit field
  Future<void> editField(String field) async {
  }
  @override
  void initState() {
    super.initState();
    handleGetFriends();
    getUserStuff(currentUser.uid);
  }

  void _logout(BuildContext context) {
    Auth().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  void handleGetFriends() {
    service.getAthletesForAssignment().then((value) {
      setState(() {
        _friends = ValueNotifier(value);
      });
    });
  }

  void getUserStuff(String uid) {
    service.getUser(uid).then(
      (value) {
        setState(() {
          name =  value["name"].toString();
          gradYear = value["gradYear"].toString();
          eventGroup = value["eventGroup"].toString();
        });
      }
    );
  }

  List<String> _assignFrends(List<Map<String, dynamic>> athletes) {
    List<String> assignedFriendsIds = [];
    for (Map<String, dynamic> athlete in athletes) {
      if (athlete["selected"] == true) {
        assignedFriendsIds.add(athlete["id"]);
      }
    }
    return assignedFriendsIds;
  }
  
  Future<bool?> _showUserSelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: _friends,
          builder: (context, value, _) {
            return Dialog(
              child: SizedBox(
                width: 200,
                height: 550,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Checkbox(
                                    value: _friends.value[index]["selected"],
                                    onChanged: (isSelected) {
                                      _friends.value[index]["selected"] =
                                          isSelected ?? false;
                                      _friends.notifyListeners();
                                    },
                                  ),
                                  const SizedBox(width: 30),
                                  Text("${value[index]["name"]}"),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            donePressed = false;
                            Navigator.of(context).pop(false); // Close dialog, return false
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            List<String> assignedFriendsIds = _assignFrends(_friends.value);
                            service.addFriend(currentUser.uid, assignedFriendsIds);
                            donePressed = true;
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("Done"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getUserStuff(currentUser.uid);
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Profile",
        context: context,
        leadingActions:
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showUserSelectionDialog(context).then((_) {

              });
            },
          ),
        trailingActions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50),
          
          //profile pic
          Icon(
            Icons.person,
            size: 72,
          ),
          
          const SizedBox(height: 10),

          //user email
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 50),

          //user details
          Padding(
            padding:  const EdgeInsets.all(8.0),
            child: Text('My Details'),
          ),

          //username
          UserTextBox(
            text: name, 
            sectionName: 'Name',
            onPressed: () => editField('Name'),
          ),
          
          //bio
          UserTextBox(
            text: gradYear, 
            sectionName: 'Graduation Year',
            onPressed: () => editField('Graduation Year'),
          ),

          UserTextBox(
            text: eventGroup, 
            sectionName: 'Event Group',
            onPressed: () => editField('Event Group'),
          ),
        ],
      )
    );
  }
}
