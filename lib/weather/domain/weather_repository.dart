import 'package:dartz/dartz.dart';

import 'package:weather_app/core/domain/fresh.dart';
import 'package:weather_app/weather/domain/weather.dart';
import 'package:weather_app/weather/domain/weather_failure.dart';

abstract class WeatherRepository {
  Future<Either<WeatherFailure, Fresh<Weather>>> getWeather(double lat, double lon);
  // Future<Either<WeatherFailure, Fresh<List<DailyWeather>>>> getDailyWeather(double lat, double lon);
  // Future<Either<WeatherFailure, Fresh<List<HourlyWeather>>>> getHourlyWeather(double lat, double lon);
}
