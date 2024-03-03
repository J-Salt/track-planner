// Rep widget
import 'package:flutter/material.dart';

class Rep extends StatefulWidget {
  final ValueChanged<String> onDistanceChanged; // Callback function
  final String numReps;
  final String rest;

  const Rep({
    super.key,
    required this.onDistanceChanged,
    required this.numReps,
    required this.rest,
  });

  @override
  _RepState createState() => _RepState();
}

class _RepState extends State<Rep> {
  String _distance = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _distance = value;
              });
              widget.onDistanceChanged(value); // Call callback function
            },
          ),
        ),
        Expanded(child: DropdownButton(items: null, onChanged: null)),
        Expanded(child: DropdownButton(items: null, onChanged: null)),
      ],
    );
  }
}
