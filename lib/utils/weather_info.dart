/// Model class for [WeatherInfo] </br>
/// [weather] is a one word description of the current weather </br>
/// [temp] is the current temperature </br>
class WeatherInfo {
  final String weather;
  final double temp;
  WeatherInfo({required this.temp, required this.weather});
}
