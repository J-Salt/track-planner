import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_planner/calendar.dart';
import 'package:track_planner/utils/reusable_appbar.dart';

class CreateWorkout extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ReusableAppBar(
        context: context,
        pageTitle: "Create Workout",
        trailingActions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Text(ref.read(selectedDayProvider.notifier).state.toString())
        ]),
      ),
    );
  }
}
