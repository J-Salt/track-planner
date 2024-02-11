import 'package:flutter/material.dart';
import 'package:track_planner/auth.dart';
import 'package:track_planner/login.dart';
import 'service.dart';

class Profile extends StatelessWidget {
  Service service = Service();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        TextButton(
                          onPressed: () => service.createUser(
                              Auth().currentUser!.uid,
                              {"name": "John", "gradYear": 2024}),
                          child: const Text("Create User"),
                        ),
                        TextButton(
                          onPressed: () => {
                            Auth().signOut(),
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()))
                          },
                          child: const Text("Logout"),
                        ),
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
