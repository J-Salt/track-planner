import 'package:flutter/material.dart';
import 'package:track_planner/utils/workout.dart';
import 'package:track_planner/view_workout.dart';

class PreviewWorkout extends StatelessWidget {
  final DisplayWorkout workout;
  const PreviewWorkout({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewWorkout(workout: workout))),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // summary and edit button
              Text(
                "${workout.name}'s Workout",
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              // details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Distance:'
                  ),
                  Text(
                    '${workout.totalDistance} Meters',
                    style: TextStyle(
                      fontSize: 20
                    )
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Time:'),
                  Text(
                    '${workout.totalTime.inMinutes.toString()} Minutes',
                    style: TextStyle(
                      fontSize: 20
                    )
                  ),
                ],
              ),
              Text('Date: ${workout.date.toIso8601String()}')
            ],
          ),
        )
      ),
    );
  }
}
