import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_weather_app/model/weather_data_hourly.dart';
import 'package:my_weather_app/model/weather_data_daily.dart';
import 'package:my_weather_app/model/weather_data_current.dart';
import 'package:logger/logger.dart';

class WeatherService {
  final String _apiKey;
  final String _baseUrl = 'https://api.weatherapi.com/v1';
  final Logger _logger = Logger();

  WeatherService() : _apiKey = const String.fromEnvironment('WEATHER_API_KEY') {
    if (_apiKey.isEmpty) {
      throw Exception("API key is missing or invalid");
    }
  }

  /// Construct the full API URL for the given latitude and longitude.
  String apiURL(double lat, double lon) {
    return '$_baseUrl/forecast.json?key=$_apiKey&q=$lat,$lon&days=7&hourly=1';
  }

  /// Helper method to make HTTP requests and parse responses.
  Future<Map<String, dynamic>> _fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.body}');
      }
    } catch (e) {
      _logger.e("Error in _fetchData: $e");
      rethrow;
    }
  }

  /// Fetch the current weather data for the given city.
  Future<WeatherDataCurrent> getCurrentWeather(String city) async {
    final url = '$_baseUrl/current.json?key=$_apiKey&q=$city&lang=es';
    final data = await _fetchData(url);
    return WeatherDataCurrent.fromJson(data);
  }

  /// Fetch the hourly weather forecast for the next 24 hours for the given city.
  Future<List<WeatherDataHourly>> getHourlyForecast(String city) async {
    final url = '$_baseUrl/forecast.json?key=$_apiKey&q=$city&hours=24&lang=es';
    final data = await _fetchData(url);

    if (data.containsKey('forecast') &&
        data['forecast'].containsKey('forecastday') &&
        data['forecast']['forecastday'].isNotEmpty) {
      final hourlyData = data['forecast']['forecastday'][0]['hour'] as List;
      return hourlyData.map((data) => WeatherDataHourly.fromJson(data)).toList();
    } else {
      throw Exception('Invalid hourly forecast data structure');
    }
  }

  /// Fetch the daily weather forecast for the next 10 days for the given city.
  Future<List<WeatherDataDaily>> getDailyForecast(String city) async {
    final url = '$_baseUrl/forecast.json?key=$_apiKey&q=$city&days=10&lang=es';
    final data = await _fetchData(url);

    if (data.containsKey('forecast') && data['forecast'].containsKey('forecastday')) {
      final dailyData = data['forecast']['forecastday'] as List;
      return dailyData.map((data) => WeatherDataDaily.fromJson(data)).toList();
    } else {
      throw Exception('Invalid daily forecast data structure');
    }
  }

  /// Fetch the weather data using latitude and longitude.
  Future<WeatherDataCurrent> getCurrentWeatherByLocation(double lat, double lon) async {
    final url = apiURL(lat, lon);
    final data = await _fetchData(url);
    return WeatherDataCurrent.fromJson(data);
  }
}