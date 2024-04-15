import 'package:flutter/material.dart';
import 'package:track_planner/utils/workout.dart';


class SetSummary extends StatelessWidget {
  final int setNumber;
  final Set set;
  const SetSummary({super.key, required this.set, required this.setNumber});


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
        children: [
          Text(
            'Set $setNumber',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[500]
            ),
          ),
          ListView.builder(
            itemCount: set.reps.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: const Icon(Icons.lock_clock),
                title: Text(set.reps[index].distance),
                trailing: Text(set.reps[index].repRunTimes![index].toString()),
              );
            },
          ),
        ],
      ),
    );
  }
}