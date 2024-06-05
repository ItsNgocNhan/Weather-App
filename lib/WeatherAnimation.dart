import 'package:flutter/material.dart';


enum WeatherType { sunny, rainy, cloudy }

class WeatherAnimation extends StatelessWidget {
  final WeatherType weatherType;

  WeatherAnimation({required this.weatherType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _getGradient(),
      ),
    );
  }

  LinearGradient _getGradient() {
    switch (weatherType) {
      case WeatherType.sunny:
        return LinearGradient(
          colors: [Colors.orange, Colors.yellow],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherType.rainy:
        return LinearGradient(
          colors: [Colors.blueGrey, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case WeatherType.cloudy:
        return LinearGradient(
          colors: [Colors.grey, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return LinearGradient(
          colors: [Colors.orange, Colors.yellow],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
