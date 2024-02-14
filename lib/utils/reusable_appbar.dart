import 'package:flutter/material.dart';

class ReusableAppBar extends AppBar {
  ///A reusable app bar widget. </br></br>
  /// [pageTitle] title of the current page </br>
  /// [context] build context of the current page </br>
  /// [trailingActions] list of actions (IconButtons) to trail the title </br>
  /// [leadingActions] list of actions (IconButtons) to precede the title </br>
  ReusableAppBar(
      {super.key,
      required this.pageTitle,
      required this.context,
      trailingActions,
      leadingActions})
      : super(
          title: Text(pageTitle),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: trailingActions,
          leading: leadingActions,
        );
  final String pageTitle;
  final BuildContext context;
  late List<Widget> trailingActions;
  late List<Widget> leadingActions;
}
