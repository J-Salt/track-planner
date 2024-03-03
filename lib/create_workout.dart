import 'package:flutter/material.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/set.dart'; // Assuming Rep widget is in a file named 'rep.dart'

class CreateWorkout extends StatefulWidget {
  const CreateWorkout();

  @override
  _CreateWorkoutState createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends State<CreateWorkout> {
  List<List<Map<String, String>>> sets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        context: context,
        pageTitle: "Create Workout",
        trailingActions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              for (int i = 0; i < sets.length; i++) {
                print('Set ${i + 1}:');
                for (int j = 0; j < sets[i].length; j++) {
                  print('  Rep ${j + 1}:');
                  print('    Distance: ${sets[i][j]['distance']}');
                  print('    numReps: ${sets[i][j]['numReps']}');
                  print('    rest: ${sets[i][j]['rest']}');
                }
              }
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: sets.length,
        itemBuilder: (context, index) {
          return Set(
            reps: sets[index],
            onAddRep: () {
              setState(() {
                sets[index].add({
                  'distance': '',
                  'numReps': '',
                  'rest': '',
                });
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            sets.add([]);
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
