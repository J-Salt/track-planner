import 'package:flutter/material.dart';

class PreviewWorkout extends StatelessWidget {
  const PreviewWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 200,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}