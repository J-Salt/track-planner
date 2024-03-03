// Set widget
import 'package:flutter/material.dart';
import 'package:track_planner/utils/rep.dart';

class Set extends StatefulWidget {
  final List<Map<String, String>>
      reps; // List of maps to store user-entered values
  final VoidCallback onAddRep;

  Set({required this.reps, required this.onAddRep});

  @override
  _SetState createState() => _SetState();
}

class _SetState extends State<Set> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          for (int i = 0; i < widget.reps.length; i++)
            Rep(
              onDistanceChanged: (distance) {
                setState(() {
                  widget.reps[i]['distance'] = distance;
                });
              },
              numReps: widget.reps[i]['numReps'] ?? '',
              rest: widget.reps[i]['rest'] ?? '',
            ),
          ElevatedButton(
            onPressed: widget.onAddRep,
            child: Text('Add Rep'),
          ),
        ],
      ),
    );
  }
}
