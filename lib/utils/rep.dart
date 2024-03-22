// Rep widget
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';

class Rep extends StatefulWidget {
  final ValueChanged<String> onDistanceChanged; // Callback function
  final ValueChanged<String> onNumRepsChanged;
  final ValueChanged<Duration> onRepRestChanged;

  const Rep({
    super.key,
    required this.onDistanceChanged,
    required this.onNumRepsChanged,
    required this.onRepRestChanged,
  });

  @override
  _RepState createState() => _RepState();
}

class _RepState extends State<Rep> {
  String _distance = '';
  dynamic _numReps = '';
  Duration _repRest = Duration(seconds: 0);

  List<DropdownMenuEntry> numRepsItems = [
    const DropdownMenuEntry(value: 1, label: "x1"),
    const DropdownMenuEntry(value: 2, label: "x2"),
    const DropdownMenuEntry(value: 3, label: "x3"),
    const DropdownMenuEntry(value: 4, label: "x4"),
    const DropdownMenuEntry(value: 5, label: "x5"),
    const DropdownMenuEntry(value: 6, label: "x6"),
    const DropdownMenuEntry(value: 7, label: "x7"),
    const DropdownMenuEntry(value: 8, label: "x8"),
    const DropdownMenuEntry(value: 9, label: "x9"),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: TextField(
              decoration: InputDecoration(hintText: "Distance"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _distance = value;
                });
                widget.onDistanceChanged(value); // Call callback function
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
          DropdownMenu(
            dropdownMenuEntries: numRepsItems,
            hintText: "Reps",
            inputDecorationTheme: InputDecorationTheme(
              constraints: BoxConstraints.tight(
                Size.fromWidth(80),
              ),
            ),
            onSelected: (value) {
              // value = int
              setState(() {
                _numReps = "$value";
              });
              widget.onNumRepsChanged(_numReps); // Call callback function
            },
          ),
          IconButton(onPressed: () => {onTap()}, icon: Icon(Icons.timer)),
          Text("${_repRest.inMinutes}:${twoDigitSeconds(_repRest)}"),
        ],
      ),
    );
  }

  String twoDigitSeconds(Duration duration) {
    int seconds = duration.inSeconds % 60;
    if (seconds == 0) {
      return "00";
    } else if (seconds < 10) {
      return "0$seconds";
    } else {
      return "$seconds";
    }
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
        setState(() {
          _repRest = _duration;
        });
        widget.onRepRestChanged(_duration);
      },
    ).showDialog(context);
  }
}
