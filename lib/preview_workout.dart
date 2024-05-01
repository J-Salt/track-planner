import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_planner/utils/workout.dart';
import 'package:track_planner/view_workout.dart';
import 'package:weather_icons/weather_icons.dart';

class PreviewWorkout extends StatelessWidget {
  final DisplayWorkout workout;
  const PreviewWorkout({super.key, required this.workout});

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
    return Card(
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewWorkout(workout: workout))),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // summary and edit button
              Text(
                "${workout.name}'s Workout",
                style: const TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              // details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Distance:'),
                  Text('${workout.totalDistance} Meters',
                      style: TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Time:'),
                  Text('${workout.totalTime.inMinutes.toString()} Minutes',
                      style: TextStyle(fontSize: 20)),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date: ${DateFormat.yMMMMd().format(workout.date)}'),
                  Row(
                    children: [
                      getWeatherIcon(),
                      Text('\t\t${StringUtils.capitalize(workout.weather)}'),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
