import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng thời tiết',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = "Hà Nội";
  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? _forecastData;
  TextEditingController get _controller => TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';  // Reset lỗi trước khi lấy dữ liệu
    });

    try {
      final weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=16eb63d06395207cec65826fd72583b2&units=metric'));

      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);
        setState(() {
          _weatherData = weatherData;
          _errorMessage = '';
        });
        await _fetchForecast(weatherData['coord']['lat'], weatherData['coord']['lon']);
      } else {
        setState(() {
          _weatherData = null;
          _forecastData = null;
          _errorMessage = 'Không tìm thấy thành phố hoặc lỗi kết nối.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Lỗi: $error';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchForecast(double lat, double lon) async {
    try {
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=16eb63d06395207cec65826fd72583b2&units=metric'));

      if (forecastResponse.statusCode == 200) {
        setState(() {
          _forecastData = json.decode(forecastResponse.body);
        });
      } else {
        setState(() {
          _forecastData = null;
          _errorMessage = 'Lỗi khi lấy dữ liệu dự báo.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Lỗi: $error';
      });
    }
  }

  void _searchWeather() {
    setState(() {
      cityName = _controller.text;
      _fetchWeather();
    });
  }


  String _getBackgroundImage() {
    if (_weatherData == null) return 'assets/images/1111515.jpg';
    String description = _weatherData!['weather'][0]['description'];
    if (description.contains('rain')) {
      return 'assets/images/rain.jpg';
    } else if (description.contains('cloud')) {
      return 'assets/images/Cloudy.jpg';
    } else if (description.contains('clear') || description.contains('clean')) {
      return 'assets/images/ClearSky.jpg';
    } else {
      return 'assets/images/1111515.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ứng dụng thời tiết'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_getBackgroundImage()),
                  fit: BoxFit.cover,
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      labelText: 'Nhập tên thành phố',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onSubmitted: (_) => _searchWeather(),
                  ),
                ),
                _errorMessage.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                )
                    : _weatherData == null
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Vị trí của tôi',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'TP. ${_weatherData!['name']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${_weatherData!['main']['temp']}°C',
                        style: const TextStyle(
                          fontSize: 64,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${(_weatherData!['main']['temp'] * 9 / 5 + 32).toStringAsFixed(1)}°F',
                        style: const TextStyle(
                          fontSize: 64,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${_weatherData!['weather'][0]['description']}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'C: ${_weatherData!['main']['temp_max']}° T: ${_weatherData!['main']['temp_min']}°',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_forecastData == null) const CircularProgressIndicator() else Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Dự báo theo giờ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 100,
                                    child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _forecastData!['list'].length,
                                    itemBuilder: (context, index) {
                                      var hourlyData = _forecastData!['list'][index];
                                      var time = DateTime.fromMillisecondsSinceEpoch(hourlyData['dt'] * 1000);
                                      var formattedTime = DateFormat('HH:mm').format(time);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              formattedTime,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/icons/${hourlyData['weather'][0]['icon']}.svg',
                                              height: 50,
                                              width: 50,
                                            ),
                                            Text(
                                              '${hourlyData['main']['temp']}°',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Dự báo 5 ngày',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    itemCount: _forecastData!['list'].length ~/ 8,
                                    itemBuilder: (context, index) {
                                      var dailyData = _forecastData!['list'][index * 8];
                                      var date = DateTime.fromMillisecondsSinceEpoch(dailyData['dt'] * 1000);
                                      var formattedDate = DateFormat('EEEE, MMM d').format(date);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              formattedDate,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/icons/${dailyData['weather'][0]['icon']}.svg',
                                              height: 50,
                                              width: 50,
                                            ),
                                            Text(
                                              '${dailyData['main']['temp_min']}° / ${dailyData['main']['temp_max']}°',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
