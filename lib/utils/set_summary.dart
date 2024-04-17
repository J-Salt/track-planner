import 'package:flutter/material.dart';
import 'package:track_planner/utils/workout.dart';


class SetSummary extends StatelessWidget {
  final int setNumber;
  final Set set;
  const SetSummary({super.key, required this.set, required this.setNumber});


  @override
  Widget build(BuildContext context) {
    if (set.reps[0].repRunTimes!.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: 
          Column(
            children: [
              Text(
                'Set $setNumber',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500]
                ),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: set.reps.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.lock_clock),
                      title: Text('${set.reps[index].numReps.toString()}x ${set.reps[index].distance} meters @ ${set.reps[index].repTime.inSeconds.toString()} seconds'),
                      //trailing: Text('${set.reps[index].repRunTimes?[index].inSeconds.toString()} seconds'),
                    );
                  },
                ),
              )
            ],
          ),  
      );
    }
    else{
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: 
          Column(
            children: [
              Text(
                'Set $setNumber',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500]
                ),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: set.reps.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.lock_clock),
                      title: Text('${set.reps[index].numReps.toString()}x ${set.reps[index].distance} meters @ ${set.reps[index].repTime.inSeconds.toString()} seconds'),
                      trailing: Text('${set.reps[index].repRunTimes?[index].inSeconds.toString()} seconds'),
                    );
                  },
                ),
              )
            ],
          ),  
      );
    }
  }
}

/*
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
                  title: Text('${set.reps[index].numReps.toString()}x ${set.reps[index].distance} meters @ ${set.reps[index].repTime.inSeconds.toString()} seconds'),
                  //trailing: Text('${set.reps[index].repRunTimes?[index].inSeconds.toString()} seconds'),
                );
              },
            ),
          ],
        ),
*/