import 'package:flutter/material.dart';
import 'package:track_planner/utils/reusable_appbar.dart';

class Activities extends StatelessWidget {
  const Activities({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        pageTitle: "Activities",
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'ACTIVITES PAGE',
            ),
          ],
        ),
      ),
    );
  }
}
