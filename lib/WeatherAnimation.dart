import 'package:flutter/material.dart';


enum WeatherType { sunny, rainy, cloudy }

class WeatherAnimation extends StatelessWidget {
  final WeatherType weatherType;

  WeatherAnimation({required this.weatherType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _getImage(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  AssetImage _getImage() {
    switch (weatherType) {
      case WeatherType.sunny:
        return AssetImage('assets/sunny.gif');
      case WeatherType.rainy:
        return AssetImage('assets/rain.gif');
      case WeatherType.cloudy:
        return AssetImage('assets/cloudy.gif');
      default:
        return AssetImage('assets/default.gif');
    }
  }
}
