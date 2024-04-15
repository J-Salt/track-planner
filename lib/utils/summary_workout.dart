import 'package:flutter/material.dart';
import 'package:track_planner/utils/workout.dart';
import 'package:track_planner/service.dart';

class WorkoutSummary extends StatelessWidget {
  const WorkoutSummary({super.key, required this.workout});
  final Workout workout;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
              Text('Total Distance:'),
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
          Column(
            children: [
              Text('Notes:'),
              Text(
                workout.notes,
                style: TextStyle(
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
              ),
              Text(workout.date.toString()),
            ],
          ),       
        ],
      ),
    );
  }
}
