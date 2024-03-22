// Set widget
import 'package:flutter/material.dart';
import 'package:track_planner/utils/rep.dart';
import 'package:flutter_picker/picker.dart';

class Set extends StatefulWidget {
  final List<Map<String, String>>
      reps; // List of maps to store user-entered values
  final VoidCallback onAddRep;
  final ValueChanged<Duration> onSetRestChanged;
  final Duration setRest;

  Set(
      {required this.reps,
      required this.onAddRep,
      required this.onSetRestChanged,
      required this.setRest});

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
              onNumRepsChanged: (numReps) {
                setState(() {
                  widget.reps[i]['numReps'] = numReps;
                });
              },
              onRepRestChanged: (repRest) {
                setState(() {
                  widget.reps[i]['repRest'] = repRest.toString();
                });
              },
            ),
          ElevatedButton(
            onPressed: widget.onAddRep,
            child: Text('Add Rep'),
          ),
          ElevatedButton(
            onPressed: () {
              onTap();
              setState() {}
            },
            child: Text('Set Rest'),
          ),
        ],
      ),
    );
  }

  void onTap() {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 999, suffix: Text(' minutes')),
        const NumberPickerColumn(
            begin: 0, end: 60, suffix: Text(' seconds'), jump: 5),
      ]),
      delimiter: <PickerDelimiter>[
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      confirmText: 'OK',
      confirmTextStyle:
          TextStyle(inherit: false, color: Colors.red, fontSize: 22),
      title: const Text('Select duration'),
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        // You get your duration here
        Duration _duration = Duration(
            minutes: picker.getSelectedValues()[0],
            seconds: picker.getSelectedValues()[1]);
        widget.onSetRestChanged(_duration);
      },
    ).showDialog(context);
  }
}
