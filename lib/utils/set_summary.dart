import 'package:flutter/material.dart';

class SetSummary extends StatelessWidget {
  
  final void Function()? onPressed;
  const SetSummary({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // summary and edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Set #',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500]
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}