import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:track_planner/calendar.dart';
import 'package:track_planner/service.dart';
import 'package:track_planner/utils/reusable_appbar.dart';

class CreateWorkout extends ConsumerWidget {
  CreateWorkout({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final DateFormat titleFormat = DateFormat("EEE, MMM d");
  List<Object> sets = [
    {
      "test": "test",
    },
    {
      "test": "test",
    }
  ];
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ReusableAppBar(
        context: context,
        pageTitle:
            titleFormat.format(ref.read(selectedDayProvider.notifier).state),
        trailingActions: [
          IconButton(
            onPressed: () => {
              Service().createActivity(
                  titleController.text, descController.text, sets)
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          const Text("Title:"),
          TextField(
            controller: titleController,
          ),
          const Text("Description:"),
          TextField(
            controller: descController,
          ),
          ElevatedButton(onPressed: () => {}, child: const Text("Add Set"))
        ]),
      ),
    );
  }
}
