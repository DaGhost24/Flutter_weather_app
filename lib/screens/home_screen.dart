import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_weather_app/controller/global_controller.dart';
import 'package:my_weather_app/utils/custom_colours.dart';
import 'package:my_weather_app/widgets/comfort_level.dart';
import 'package:my_weather_app/widgets/current_weather_widget.dart';
import 'package:my_weather_app/widgets/daily_data_forecast.dart';
import 'package:my_weather_app/widgets/header_widget.dart';
import 'package:my_weather_app/widgets/hourly_data_widget.dart'; // Ensure correct import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalController controller = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => controller.isLoading.isTrue
            ? _buildLoading()
            : _buildContent()),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/clouds.png",
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: () => controller.getLocation(),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          const HeaderWidget(),
          const SizedBox(height: 20),
          CurrentWeatherWidget(
            weatherDataCurrent: controller.weather.getCurrentWeather(),
          ),
          const SizedBox(height: 20),
          HourlyForecast( // Ensure widget name matches your implementation
            weatherDataHourly: controller.weather.getHourlyWeather(),
          ),
          const SizedBox(height: 20),
          DailyDataForecast(
            weatherDataDaily: controller.weather.getDailyWeather(),
          ),
          const SizedBox(height: 20),
          const Divider(
            color: CustomColors.dividerLine,
            height: 1,
            thickness: 1,
          ),
          const SizedBox(height: 20),
          ComfortLevel(
            weatherDataCurrent: controller.weather.getCurrentWeather(),
          ),
        ],
      ),
    );
  }
}