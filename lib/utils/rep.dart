// Rep widget
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';

class Rep extends StatefulWidget {
  final ValueChanged<String> onDistanceChanged; // Callback function
  final ValueChanged<String> onNumRepsChanged;
  final ValueChanged<Duration> onRepRestChanged;
  final ValueChanged<Duration> onRepTimeChanged;

  const Rep(
      {super.key,
      required this.onDistanceChanged,
      required this.onNumRepsChanged,
      required this.onRepRestChanged,
      required this.onRepTimeChanged});

  @override
  _RepState createState() => _RepState();
}

class _RepState extends State<Rep> {
  String _distance = '';
  dynamic _numReps = '';
  Duration _repRest = const Duration(seconds: 0);
  Duration _repTime = const Duration(seconds: 0);

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
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  decoration: const InputDecoration(hintText: "Distance"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _distance = value;
                    });
                    widget.onDistanceChanged(value); // Call callback function
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              DropdownMenu(
                dropdownMenuEntries: numRepsItems,
                hintText: "Reps",
                inputDecorationTheme: InputDecorationTheme(
                  constraints: BoxConstraints.tight(const Size(100, 50)),
                ),
                onSelected: (value) {
                  // value = int
                  setState(() {
                    _numReps = "$value";
                  });
                  widget.onNumRepsChanged(_numReps); // Call callback function
                },
              ),
              Expanded(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => {onTapRepTime("Select rep time")},
                      child: Row(children: [
                        const Icon(Icons.directions_run),
                        Text(
                            "${_repTime.inMinutes}:${twoDigitSeconds(_repTime)}"),
                      ]),
                    ),
                    ElevatedButton(
                      onPressed: () => {onTap("Select rep rest")},
                      child: Row(children: [
                        const Icon(Icons.timer),
                        Text(
                            "${_repRest.inMinutes}:${twoDigitSeconds(_repRest)}"),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      selectedTextStyle: const TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        // You get your duration here
        Duration duration = Duration(
            minutes: picker.getSelectedValues()[0],
            seconds: picker.getSelectedValues()[1]);
        setState(() {
          _repRest = duration;
        });
        widget.onRepRestChanged(duration);
      },
    ).showDialog(context);
  }

  void onTapRepTime(String title) {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' minutes')),
        const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' seconds')),
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
      selectedTextStyle: const TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        // You get your duration here
        Duration duration = Duration(
            minutes: picker.getSelectedValues()[0],
            seconds: picker.getSelectedValues()[1]);
        setState(() {
          _repTime = duration;
        });
        widget.onRepTimeChanged(duration);
      },
    ).showDialog(context);
  }
}
