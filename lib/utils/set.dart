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
  final int index;

  Set(
      {required this.reps,
      required this.index,
      required this.onAddRep,
      required this.onSetRestChanged,
      required this.setRest});

  @override
  _SetState createState() => _SetState();
}

class _SetState extends State<Set> {
  Duration _setRest = Duration(seconds: 0);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5.0, 0.0, 0.0),
            child: Text(
              "Set ${widget.index + 1}",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Divider(),
          ),
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
              onRepTimeChanged: (repTime) {
                setState(() {
                  widget.reps[i]['repTime'] = repTime.toString();
                });
              },
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 12.0, 0.0),
                  child: SizedBox(
                    width: 120,
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text("Rest", style: TextStyle(fontSize: 16)),
                    Text(displayDuration(_setRest),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0.0, 24.0, 0.0),
                  child: SizedBox(
                    width: 120,
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: widget.onAddRep,
                  child: Text('Add Rep'),
                ),
                ElevatedButton(
                  onPressed: () {
                    onTap("Select set rest");
                    setState() {}
                  },
                  child: Text('Set ${widget.index + 1} Rest'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String displayDuration(Duration duration) {
    String out = "${duration.inMinutes}:";
    int seconds = duration.inSeconds % 60;
    if (seconds == 0) {
      out += "00";
    } else if (seconds < 10) {
      out += "0${seconds}";
    } else {
      out += "${seconds}";
    }

    return out;
  }

  void onTap(String title) {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' minutes')),
        const NumberPickerColumn(
            begin: 0, end: 55, suffix: Text(' seconds'), jump: 5),
      ]),
      delimiter: <PickerDelimiter>[
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: const Text(
              ":",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
      hideHeader: true,
      confirmText: 'OK',
      confirmTextStyle:
          const TextStyle(inherit: false, color: Colors.red, fontSize: 22),
      title: Text(title),
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        // You get your duration here
        Duration _duration = Duration(
            minutes: picker.getSelectedValues()[0],
            seconds: picker.getSelectedValues()[1]);
        widget.onSetRestChanged(_duration);
        setState(() {
          _setRest = _duration;
        });
      },
    ).showDialog(context);
  }
}
