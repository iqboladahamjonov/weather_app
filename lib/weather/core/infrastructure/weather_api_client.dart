import 'package:dio/dio.dart';

class WeatherApiClient {
  static const API_KEY = "e4c43583f2510660f852993c5c4500ee";
  final Dio dio;
  WeatherApiClient(this.dio) {
    dio.options.baseUrl = "https://api.openweathermap.org/data/2.5/onecall?appid=${API_KEY}&";
    // dio.options.baseUrl = "https://api.openweathermap.org/";
  }
}
