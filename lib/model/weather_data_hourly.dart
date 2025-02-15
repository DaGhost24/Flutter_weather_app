import 'dart:developer';

/// Represents hourly weather forecast data containing a list of hourly weather reports
class WeatherDataHourly {
  final List<HourlyWeather> hourly;

  WeatherDataHourly({required this.hourly});

  /// Factory constructor for creating a [WeatherDataHourly] instance from JSON data
  factory WeatherDataHourly.fromJson(Map<String, dynamic> json) {
    try {
      final forecastDays = (json['forecast']?['forecastday'] as List?) ?? [];

      // Extract and parse all hourly data from multiple forecast days
      final allHourlyData = forecastDays.expand<HourlyWeather>((day) {
        final hourlyData = (day['hour'] as List?) ?? [];
        return hourlyData.map<HourlyWeather>(
              (item) => HourlyWeather.fromJson(item as Map<String, dynamic>),
        );
      }).toList();

      if (allHourlyData.isEmpty) {
        log('Warning: No hourly data found in API response',
            name: 'WeatherDataHourly');
      }

      return WeatherDataHourly(hourly: allHourlyData);
    } catch (e, stackTrace) {
      log('Error parsing hourly weather data: $e',
          error: e, stackTrace: stackTrace, name: 'WeatherDataHourly');
      rethrow;
    }
  }

  /// Converts the [WeatherDataHourly] instance to JSON format
  Map<String, dynamic> toJson() => {
    'hourly': hourly.map((item) => item.toJson()).toList(),
  };
}

/// Represents weather data for a specific hour
class HourlyWeather {
  final String time;          // Formatted as "HH:mm"
  final double temperature;   // In Celsius
  final double humidity;      // Percentage (0-100)
  final double windSpeed;     // In kilometers per hour
  final String condition;     // Weather condition description
  final String icon;          // URL path to weather icon

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.icon,
  });

  /// Factory constructor for creating a [HourlyWeather] instance from JSON data
  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    try {
      final rawTime = json['time'] as String? ?? '';
      final conditionData = json['condition'] as Map<String, dynamic>? ?? {};

      return HourlyWeather(
        time: _parseTime(rawTime),
        temperature: (json['temp_c'] as num?)?.toDouble() ?? 0.0,
        humidity: (json['humidity'] as num?)?.toDouble() ?? 0.0,
        windSpeed: (json['wind_kph'] as num?)?.toDouble() ?? 0.0,
        condition: conditionData['text'] as String? ?? 'Unknown',
        icon: conditionData['icon'] as String? ?? '',
      );
    } catch (e, stackTrace) {
      log('Error parsing hourly weather item: $e',
          error: e, stackTrace: stackTrace, name: 'HourlyWeather');
      rethrow;
    }
  }

  /// Converts the [HourlyWeather] instance to JSON format
  Map<String, dynamic> toJson() => {
    'time': time,
    'temp_c': temperature,
    'humidity': humidity,
    'wind_kph': windSpeed,
    'condition': condition,
    'icon': icon,
  };

  /// Parses and formats time string from API response
  static String _parseTime(String rawTime) {
    try {
      final parsedTime = DateTime.parse(rawTime);
      return '${parsedTime.hour.toString().padLeft(2, '0')}'
          ':${parsedTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      log('Invalid time format: $rawTime', name: 'HourlyWeather');
      return 'Unknown Time';
    }
  }
}