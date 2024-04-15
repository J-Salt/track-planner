import 'package:flutter/material.dart';
import 'package:track_planner/utils/workout.dart';
import 'package:track_planner/view_workout.dart';

class PreviewWorkout extends StatelessWidget {
  final Workout workout;
  const PreviewWorkout({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Workout Summary',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),

                  IconButton(
                    onPressed: (){},
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),

              // details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Distance:'
                  ),
                  Text(
                    workout.totalDistance,
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
                    workout.totalTime.toString(),
                    style: TextStyle(
                      fontSize: 20
                    )
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}
