import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:my_weather_app/api/fetch_weather.dart';
import 'package:my_weather_app/model/weather_data.dart';

class GlobalController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;
  final weatherData = WeatherData().obs;
  final Logger _logger = Logger();

  // Getters (property-style)
  RxBool get isLoading => _isLoading;
  RxDouble get latitude => _latitude;    // Correct getter name (one "t")
  RxDouble get longitude => _longitude;  // Correct getter name
  RxInt get currentIndex => _currentIndex;
  WeatherData get weather => weatherData.value;

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    }
    super.onInit();
  }

  Future<void> getLocation() async {
    try {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        throw Exception("Location services disabled");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions permanently denied");
      } else if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions denied");
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _latitude.value = position.latitude;
      _longitude.value = position.longitude;
      await fetchWeatherData(position.latitude, position.longitude);
    } catch (e) {
      _logger.e("Location Error: $e");
      _isLoading.value = false;
      rethrow;
    }
  }

  Future<void> fetchWeatherData(double lat, double lon) async {
    try {
      final data = await FetchWeatherAPI().processData(lat, lon);
      weatherData.value = data;
      _isLoading.value = false;
    } catch (e) {
      _logger.e("Weather Data Error: $e");
      _isLoading.value = false;
      rethrow;
    }
  }
}