import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:track_planner/auth.dart';
import 'package:track_planner/service.dart';
import 'package:track_planner/utils/reusable_appbar.dart';
import 'package:track_planner/utils/weather_info.dart';
import 'package:track_planner/utils/workout.dart';

// Log workout page
class LogWorkout extends StatefulWidget {
  const LogWorkout({super.key, required this.workout});
  final Workout workout;

  @override
  _LogWorkoutState createState() => _LogWorkoutState();
}

class _LogWorkoutState extends State<LogWorkout> {
  int _selectedSet = 0;
  int _selectedRep = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        context: context,
        pageTitle: "Workout",
        trailingActions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              WeatherInfo weather = await fetchWeather();
              await Service().logWorkout(Auth().currentUser!.uid,
                  widget.workout.id, widget.workout.sets, weather);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          //build sets
          itemCount: widget.workout.sets.length,
          itemBuilder: (context, setIndex) {
            return Card(
              elevation: 2,
              child: Column(
                children: [
                  Container(
                    width: 600,
                    height: widget.workout.sets[setIndex].reps.length * 100,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      //build reps
                      itemCount: widget.workout.sets[setIndex].reps.length,
                      itemBuilder: (context, repIndex) {
                        return InkWell(
                          onTap: () async {
                            setState(() {
                              _selectedSet = setIndex;
                              _selectedRep = repIndex;
                            });

                            await _showRepLoggingDialog(context,
                                widget.workout.sets[setIndex].reps[repIndex]);
                          },
                          child: Card(
                            elevation: 3,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${repIndex + 1}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                      Icon(
                                        Icons.check,
                                        color: Colors.green.withOpacity(widget
                                                    .workout
                                                    .sets[setIndex]
                                                    .reps[repIndex]
                                                    .repRunTimes
                                                    ?.length ==
                                                int.parse(widget
                                                    .workout
                                                    .sets[setIndex]
                                                    .reps[repIndex]
                                                    .numReps)
                                            ? 1
                                            : 0),
                                      )
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Text(
                                          "${widget.workout.sets[setIndex].reps[repIndex].distance}m x ${widget.workout.sets[setIndex].reps[repIndex].numReps}"),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      const Icon(Icons.timer),
                                      Text(
                                          "${widget.workout.sets[setIndex].reps[repIndex].repTime.inMinutes}:${widget.workout.sets[setIndex].reps[repIndex].repTime.inSeconds % 60 == 0 ? "00" : widget.workout.sets[setIndex].reps[repIndex].repTime.inSeconds % 60}")
                                    ],
                                  ),
                                  Text(
                                      "Rest: ${widget.workout.sets[setIndex].reps[repIndex].repRest.inMinutes}:${widget.workout.sets[setIndex].reps[repIndex].repRest.inSeconds % 60 == 0 ? "00" : widget.workout.sets[setIndex].reps[repIndex].repRest.inSeconds % 60}")
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Helper function to fetch the current weather base on the users location
  Future<WeatherInfo> fetchWeather() async {
    await Geolocator.checkPermission().then((value) {
      switch (value) {
        case LocationPermission.denied:
          Geolocator.requestPermission();
        case LocationPermission.deniedForever:
          Geolocator.requestPermission();
        case LocationPermission.unableToDetermine:
          Geolocator.requestPermission();
        default:
          //low budget logging
          print("Location status: $value");
      }
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String url =
        "https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current=temperature_2m,precipitation,wind_speed_10m,wind_gusts_10m,cloud_cover,snowfall&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      //Gather data
      Map<String, dynamic> weatherData = jsonDecode(response.body);

      Map<String, dynamic> currentWeather = weatherData["current"];
      double windSpeed =
          currentWeather["wind_speed_10m"] ?? -1; //Wind speed in m/s
      double windGusts =
          currentWeather["wind_gusts_10m"] ?? -1; //Gust speed in m/s
      double temp = currentWeather["temperature_2m"] ?? -1; //Temp in fahrenheit
      double precipitation = currentWeather["precipitation"] ??
          -1; //Inches of rain in the last hour
      int clouds = currentWeather["cloud_cover"] ?? -1; //Percent cloud cover
      double snow = currentWeather["snowfall"] ??
          -1; //Inches of snowfall in the last hour

      //Translate weather data into simple categories and temperature.
      if (windSpeed >= 18 || windGusts >= 24) {
        return WeatherInfo(temp: temp, weather: "windy");
      }
      if (precipitation > 0.1) return WeatherInfo(temp: temp, weather: "rainy");
      if (snow > 0.1) return WeatherInfo(temp: temp, weather: "snowy");
      if (clouds >= 50) {
        return WeatherInfo(temp: temp, weather: "cloudy");
      } else if (clouds >= 20) {
        return WeatherInfo(temp: temp, weather: "partly-cloudy");
      } else {
        return WeatherInfo(temp: temp, weather: "sunny");
      }
    } else {
      // If the server did not return a 200 OK response,
      // then set values to check for later
      return WeatherInfo(temp: -1, weather: "na");
    }
  }

  // Dialog to log times for each rep
  Future<bool?> _showRepLoggingDialog(
      BuildContext context, Rep selectedRep) async {
    List<TextEditingController> controllers = List.generate(
      int.parse(selectedRep.numReps),
      (index) => TextEditingController(),
    );
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 200,
            height: 550,
            child: Column(
              children: [
                Text(
                  "${selectedRep.distance} x ${selectedRep.numReps}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: int.parse(selectedRep.numReps),
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      "${index + 1}: ${selectedRep.distance}m :"),
                                  SizedBox(
                                    width: 130,
                                    child: TextField(
                                      controller: controllers[index],
                                      keyboardType: TextInputType.datetime,
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons.directions_run),
                                          hintText: "MM:SS.SS"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Close dialog, return false
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        List<Duration> times = controllers
                            .map((c) => Service().parseDuration2(c.text))
                            .toList();
                        if (hasNonZeroDurations(times)) {
                          setState(() {
                            widget.workout.sets[_selectedSet].reps[_selectedRep]
                                .repRunTimes = times;
                          });
                        }

                        Navigator.of(context).pop();
                      },
                      child: const Text("Done"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Make sure each rep is logged with a value
  bool hasNonZeroDurations(List<Duration> durations) {
    //check if a list of durations contains all zeros
    for (var duration in durations) {
      if (duration != Duration.zero) {
        return true;
      }
    }
    return false;
  }
}
