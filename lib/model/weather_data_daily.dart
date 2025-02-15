class WeatherDataDaily {
  final List<DailyForecast> daily;

  WeatherDataDaily({required this.daily});

  /// Parse from forecastday list
  factory WeatherDataDaily.fromJson(List<dynamic> json) {
    return WeatherDataDaily(
      daily: json
          .map((item) => DailyForecast.fromJson(item as Map<String, dynamic>?))
          .whereType<DailyForecast>()
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'daily': daily.map((e) => e.toJson()).toList(),
  };
}

class DailyForecast {
  final String date;
  final Temperature temp;
  final Condition condition;

  DailyForecast({
    required this.date,
    required this.temp,
    required this.condition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    final dayData = json['day'] as Map<String, dynamic>? ?? {};
    final conditionData = dayData['condition'] as Map<String, dynamic>? ?? {};

    return DailyForecast(
      date: json['date']?.toString() ?? "Unknown Date",
      temp: Temperature(
        max: (dayData['maxtemp_c'] as num?)?.toDouble() ?? 0,
        min: (dayData['mintemp_c'] as num?)?.toDouble() ?? 0,
        avg: (dayData['avgtemp_c'] as num?)?.toDouble() ?? 0,
      ),
      condition: Condition(
        text: conditionData['text']?.toString() ?? "Unknown",
        icon: conditionData['icon']?.toString() ?? "",
        code: conditionData['code'] as int? ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'day': {
      'maxtemp_c': temp.max,
      'mintemp_c': temp.min,
      'avgtemp_c': temp.avg,
      'condition': condition.toJson(),
    },
  };
}

class Temperature {
  final double max;
  final double min;
  final double avg;

  Temperature({required this.max, required this.min, required this.avg});

  Map<String, dynamic> toJson() => {
    'maxtemp_c': max,
    'mintemp_c': min,
    'avgtemp_c': avg,
  };
}

class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({required this.text, required this.icon, required this.code});

  Map<String, dynamic> toJson() => {
    'text': text,
    'icon': icon,
    'code': code,
  };
}