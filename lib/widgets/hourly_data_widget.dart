import 'package:flutter/material.dart';
import 'package:my_weather_app/model/weather_data_hourly.dart';

class HourlyForecast extends StatelessWidget {
  final WeatherDataHourly weatherDataHourly;

  const HourlyForecast({
    Key? key,
    required this.weatherDataHourly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    if (weatherDataHourly.hourly.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            'No hourly data available',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      height: 160, // Fixed height for better layout control
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weatherDataHourly.hourly.length,
        itemBuilder: (context, index) {
          final hour = weatherDataHourly.hourly[index];
          return _HourlyWeatherCard(hour: hour, isDarkMode: isDarkMode);
        },
      ),
    );
  }
}

class _HourlyWeatherCard extends StatelessWidget {
  final HourlyWeather hour;
  final bool isDarkMode;

  const _HourlyWeatherCard({
    required this.hour,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Fixed width for consistent sizing
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[900]
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black54
                : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Time
          Text(
            hour.time,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Weather Icon
          SizedBox(
            width: 40,
            height: 40,
            child: Image.network(
              'https:${hour.icon}', // Ensure HTTPS protocol
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                );
              },
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.cloud_off,
                color: isDarkMode ? Colors.white54 : Colors.grey,
              ),
            ),
          ),

          // Temperature
          Text(
            '${hour.temperature.toStringAsFixed(0)}°C', // No decimal places
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Weather Condition
          Text(
            hour.condition,
            style: TextStyle(
              color: isDarkMode ? Colors.white54 : Colors.grey[700],
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}