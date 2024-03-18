import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_planner/auth.dart';
import 'package:track_planner/login.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/user_text_box.dart';
import 'service.dart';

class Profile extends StatelessWidget {
  Service service = Service();

  void _logout(BuildContext context) {
    Auth().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  
  //edit field
  Future<void> editField(String field) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Profile",
        context: context,
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
            text: 'Lleyton Winslow', 
            sectionName: 'Name',
            onPressed: () => editField('Name'),
          ),
          
          //bio
          UserTextBox(
            text: '2024', 
            sectionName: 'Graduation Year',
            onPressed: () => editField('Graduation Year'),
          ),

          UserTextBox(
            text: 'Middle Distance', 
            sectionName: 'Event Group',
            onPressed: () => editField('Event Group'),
          ),
        ],
      )
    );
  }
}
