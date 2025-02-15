import 'package:flutter/material.dart';
import 'package:my_weather_app/model/weather_data_current.dart';
import 'package:my_weather_app/utils/custom_colours.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherDataCurrent weatherDataCurrent;

  const CurrentWeatherWidget({super.key, required this.weatherDataCurrent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Temperature area
        temperatureAreaWidget(),
        const SizedBox(height: 20),
        // More details - wind speed, humidity, clouds
        currentWeatherMoreDetailsWidget(),
      ],
    );
  }

  Widget currentWeatherMoreDetailsWidget() {
    String windSpeed = weatherDataCurrent.current.windSpeed.toStringAsFixed(1) ?? "N/A";
    String clouds = weatherDataCurrent.current.clouds.toString() ?? "N/A";
    String humidity = weatherDataCurrent.current.humidity.toString() ?? "N/A";

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            detailItem("assets/icons/windspeed.png", "$windSpeed km/h"),
            detailItem("assets/icons/clouds.png", "$clouds%"),
            detailItem("assets/icons/humidity.png", "$humidity%"),
          ],
        ),
      ],
    );
  }

  Widget detailItem(String assetPath, String value) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CustomColors.cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget temperatureAreaWidget() {
    String temperature = weatherDataCurrent.current.temp.toString() ?? "N/A";
    String description =
        weatherDataCurrent.current.weather.text ?? "N/A";
    // Remove the indexing operator since weather is a single object
    String iconCode = weatherDataCurrent.current.weather.icon ?? "default";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          "assets/weather/$iconCode.png",
          height: 80,
          width: 80,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.error, size: 80),
        ),
        Container(
          height: 50,
          width: 1,
          color: CustomColors.dividerLine,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$temperature°",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 68,
                  color: CustomColors.textColorBlack,
                ),
              ),
              TextSpan(
                text: description,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
