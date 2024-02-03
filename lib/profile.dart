import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
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
                  const Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("John Salt"),
                        ],
                      ),
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
