import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "WeatherAnimation.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng thời tiết',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _city = "Hanoi, VietNam";
  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? _forecastData;
  TextEditingController _controller = TextEditingController();
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
          'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=16eb63d06395207cec65826fd72583b2&units=metric&lang=vi'));

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
          'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=16eb63d06395207cec65826fd72583b2&units=metric&lang=vi'));

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
      _city = _controller.text;
      _fetchWeather();
    });
  }

  WeatherType _getWeatherType() {
    if (_weatherData == null) return WeatherType.sunny; // Mặc định là nắng
    String description = _weatherData!['weather'][0]['description'];
    if (description.contains('mưa')) {
      return WeatherType.rainy;
    } else if (description.contains('mây')) {
      return WeatherType.cloudy;
    } else if (description.contains('bầu trời quang đãng') || description.contains('vài đám mây')) {
      return WeatherType.sunny;
    } else {
      return WeatherType.sunny; // Hoặc bất kỳ loại thời tiết mặc định nào khác
    }
  }


  @override
  Widget build(BuildContext context) {
    WeatherType weatherType = _getWeatherType();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ứng dụng thời tiết'),
      ),
      body: Stack(
        children: [
          WeatherAnimation(
            weatherType: weatherType,
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      labelText: 'Nhập tên thành phố',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                )
                    : _weatherData == null
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Vị trí của tôi',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${_weatherData!['name']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${_weatherData!['main']['temp']}°C / ${(_weatherData!['main']['temp'] * 9 / 5 + 32).toStringAsFixed(1)}°F',
                        style: TextStyle(
                          fontSize: 64,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${_weatherData!['weather'][0]['description']}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'C: ${_weatherData!['main']['temp_min']}° T: ${_weatherData!['main']['temp_max']}°',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      if (_forecastData == null) CircularProgressIndicator() else Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Dự báo theo giờ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
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
                                              style: TextStyle(
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
                                              style: TextStyle(
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
                          // Dự báo 5 ngày
                          SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Dự báo 5 ngày',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  height: 340,
                                  child: ListView.builder(
                                    itemCount: _forecastData!['list'].length ~/ 8,
                                    itemBuilder: (context, index) {
                                      var dailyData = _forecastData!['list'][index * 8];
                                      var date = DateTime.fromMillisecondsSinceEpoch(dailyData['dt'] * 1000);
                                      var formattedDate = DateFormat('EEEE, M/d/y').format(date);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              formattedDate,
                                              style: TextStyle(
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
                                              style: TextStyle(
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

                          // ĐỘ ẨM và SỨC GIÓ
                          SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Độ ẩm và sức gió',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  height: 250,
                                  child: ListView.builder(
                                    itemCount: _forecastData!['list'].length,
                                    itemBuilder: (context, index) {
                                      var dailyData = _forecastData!['list'][index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Độ ẩm: ${dailyData['main']['humidity']}%',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                'Sức gió: ${dailyData['wind']['speed']} m/s',
                                                style: TextStyle(
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

