import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_weather_app/model/weather_data_daily.dart';
import '../utils/custom_colours.dart';

class DailyDataForecast extends StatelessWidget {
  final WeatherDataDaily weatherDataDaily;

  const DailyDataForecast({Key? key, required this.weatherDataDaily})
      : super(key: key);

  // string manipulation
  String getDay(final String date) {
    DateTime time = DateTime.parse(date);
    final x = DateFormat('EEE').format(time);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: CustomColors.dividerLine.withAlpha(150),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              "Next Days",
              style:
              TextStyle(color: CustomColors.textColorBlack, fontSize: 17),
            ),
          ),
          dailyList(),
        ],
      ),
    );
  }

  Widget dailyList() {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: weatherDataDaily.daily.length > 7
            ? 7
            : weatherDataDaily.daily.length,
        itemBuilder: (context, index) {
          final dailyForecast = weatherDataDaily.daily[index];

          // Safeguard against null values, using defaults where needed.
          final date = dailyForecast.date;
          final String iconUrl;

          if (dailyForecast.condition.icon.startsWith("http")) {
            iconUrl = dailyForecast.condition.icon;
          } else if (dailyForecast.condition.icon.isNotEmpty) {
            iconUrl = "https:${dailyForecast.condition.icon}";
          } else {
            iconUrl = "assets/weather/default.png";
          }

          final maxTemp = dailyForecast.temp.max;
          final minTemp = dailyForecast.temp.min;

          return Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        getDay(date),
                        style: const TextStyle(
                            color: CustomColors.textColorBlack, fontSize: 13),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.network(iconUrl),
                    ),
                    Text("$maxTemp°/$minTemp°")
                  ],
                ),
              ),
              Container(
                height: 1,
                color: CustomColors.dividerLine,
              )
            ],
          );
        },
      ),
    );
  }
}