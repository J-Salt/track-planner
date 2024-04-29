
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_planner/utils/workout.dart';
import 'package:track_planner/service.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:basic_utils/basic_utils.dart';

class WorkoutSummary extends StatelessWidget {
  const WorkoutSummary({super.key, required this.workout});
  final DisplayWorkout workout;

  Icon getWeatherIcon() {
    if (workout.weather == 'windy')
      return Icon(WeatherIcons.day_windy);
    else if (workout.weather == 'rainy')
      return Icon(WeatherIcons.day_rain);
    else if (workout.weather == 'cloudy')
      return Icon(WeatherIcons.cloud);
    else if (workout.weather == 'partly-cloudy')
      return Icon(WeatherIcons.night_partly_cloudy);
    else
      return Icon(WeatherIcons.day_sunny);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Workout Summary',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Distance:'),
              Text('${workout.totalDistance} Meters',
                  style: const TextStyle(fontSize: 20)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Time:'),
              Text('${workout.totalTime.inMinutes.toString()} minutes',
                  style: const TextStyle(fontSize: 20)),
            ],
          ),
          const Text('Notes:'),
          Text(
            workout.notes,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.right,
          ),
          Text('Athlete: ${workout.name}'),
          Text('Date: ${DateFormat.yMMMMd().format(workout.date)}'),
          Row(
            children: [
              getWeatherIcon(),
              Text('\t\t${StringUtils.capitalize(workout.weather)}'),
            ],
          ),
        ],
      ),
    );
  }
}
