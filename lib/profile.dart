import 'package:flutter/material.dart';
import 'package:track_planner/auth.dart';
import 'package:track_planner/login.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'service.dart';

class Profile extends StatelessWidget {
  Service service = Service();

  void _logout(BuildContext context) {
    Auth().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
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
      body: Container(
        //Adds padding around the edges
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: const Image(
                      image: AssetImage("lib/assets/empty_user.png"),
                      height: 100.0,
                      width: 100.0,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("John Salt"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
