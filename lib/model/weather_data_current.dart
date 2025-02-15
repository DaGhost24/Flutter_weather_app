class WeatherDataCurrent {
  final Current current;

  WeatherDataCurrent({required this.current});

  factory WeatherDataCurrent.fromJson(Map<String, dynamic> json) {
    try {
      if (!json.containsKey('current')) {
        throw FormatException("Root 'current' key missing");
      }

      final currentJson = json['current'] as Map<String, dynamic>;
      return WeatherDataCurrent(
        current: Current.fromJson(currentJson),
      );
    } catch (e) {
      throw FormatException("WeatherDataCurrent parsing failed: $e");
    }
  }

  Map<String, dynamic> toJson() => {
    'current': current.toJson(),
  };
}

class Current {
  final int temp;
  final int humidity;
  final int clouds;
  final double uvIndex;
  final double feelsLike;
  final double windSpeed;
  final Weather weather;

  Current({
    required this.temp,
    required this.humidity,
    required this.clouds,
    required this.uvIndex,
    required this.feelsLike,
    required this.windSpeed,
    required this.weather,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    try {
      return Current(
        temp: (json['temp_c'] as num).round(),
        humidity: json['humidity'] as int,
        clouds: json['cloud'] as int,
        uvIndex: (json['uv'] as num).toDouble(),
        feelsLike: (json['feelslike_c'] as num).toDouble(),
        windSpeed: (json['wind_kph'] as num).toDouble(),
        weather: Weather.fromJson(json['condition']),
      );
    } catch (e) {
      throw const FormatException("Current parsing failed: Missing required field");
    }
  }

  Map<String, dynamic> toJson() => {
    'temp_c': temp,
    'humidity': humidity,
    'cloud': clouds,
    'uv': uvIndex,
    'feelslike_c': feelsLike,
    'wind_kph': windSpeed,
    'condition': weather.toJson(),
  };
}

class Weather {
  final String text;
  final String icon;
  final int code;

  Weather({required this.text, required this.icon, required this.code});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      text: json['text'] as String,
      icon: json['icon'] as String,
      code: json['code'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'icon': icon,
    'code': code,
  };
}