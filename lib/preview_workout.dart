import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_planner/utils/workout.dart';
import 'package:track_planner/view_workout.dart';

class PreviewWorkout extends StatelessWidget {
  final DisplayWorkout workout;
  const PreviewWorkout({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewWorkout(workout: workout))),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // summary and edit button
              Text(
                "${workout.name}'s Workout",
                style: const TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              // details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Distance:'),
                  Text('${workout.totalDistance} Meters',
                      style: TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Time:'),
                  Text('${workout.totalTime.inMinutes.toString()} Minutes',
                      style: TextStyle(fontSize: 20)),
                ],
              ),
              Text('Date: ${DateFormat.yMMMMd().format(workout.date)}')
            ],
          ),
        ),
      ),
    );
  }
}
