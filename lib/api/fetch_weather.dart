import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:my_weather_app/api/api_key.dart';
import 'package:my_weather_app/model/weather_data.dart';
import 'package:my_weather_app/model/weather_data_current.dart';
import 'package:my_weather_app/model/weather_data_daily.dart';
import 'package:my_weather_app/model/weather_data_hourly.dart';

class FetchWeatherAPI {
  final Logger _logger = Logger();
  static const String _apiKey = apiKey; // Replace with your API key
  static const String _baseUrl = "https://api.weatherapi.com/v1";

  // Build URL for forecast (includes daily and hourly data)
  String _buildForecastUrl(double lat, double lon) {
    return "$_baseUrl/forecast.json?key=$_apiKey&q=$lat,$lon&days=7&hourly=1";
  }

  // Build URL for current weather data
  String _buildCurrentUrl(double lat, double lon) {
    return "$_baseUrl/current.json?key=$_apiKey&q=$lat,$lon&aqi=no";
  }

  /// Fetches weather data by concurrently calling the forecast and current endpoints.
  /// It passes the full forecast JSON to the hourly model so that all hourly data
  /// (from all forecast days) is aggregated.
  Future<WeatherData> processData(double lat, double lon) async {
    try {
      final forecastUrl = _buildForecastUrl(lat, lon);
      final currentUrl = _buildCurrentUrl(lat, lon);

      // Fetch both endpoints concurrently.
      final responses = await Future.wait([
        http.get(Uri.parse(forecastUrl)),
        http.get(Uri.parse(currentUrl))
      ]);

      final forecastResponse = responses[0];
      final currentResponse = responses[1];

      if (forecastResponse.statusCode != 200) {
        throw Exception("Failed to fetch forecast data. Status code: ${forecastResponse.statusCode}");
      }
      if (currentResponse.statusCode != 200) {
        throw Exception("Failed to fetch current data. Status code: ${currentResponse.statusCode}");
      }

      final forecastJson = jsonDecode(forecastResponse.body) as Map<String, dynamic>;
      final currentJson = jsonDecode(currentResponse.body) as Map<String, dynamic>;

      // Use the full forecastJson for hourly data.
      return WeatherData(
        current: WeatherDataCurrent.fromJson(currentJson),
        hourly: WeatherDataHourly.fromJson(forecastJson),
        daily: WeatherDataDaily.fromJson(
          (forecastJson['forecast'] as Map<String, dynamic>)['forecastday'] as List<dynamic>,
        ),
      );
    } catch (e, stackTrace) {
      _logger.e("Error in processData: $e", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
