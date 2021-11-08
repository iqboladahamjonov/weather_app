import 'package:dartz/dartz.dart';

import 'package:weather_app/core/domain/fresh.dart';
import 'package:weather_app/core/infrastucture/network_exceptions.dart';
import 'package:weather_app/weather/domain/weather.dart';
import 'package:weather_app/weather/domain/weather_failure.dart';
import 'package:weather_app/weather/domain/weather_repository.dart';
import 'package:weather_app/weather/infrastructure/weather_local_service.dart';
import 'package:weather_app/weather/infrastructure/weather_remote_service.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteService _remoteService;
  final WeatherLocalService _localService;

  WeatherRepositoryImpl(this._remoteService, this._localService);

  @override
  Future<Either<WeatherFailure, Fresh<Weather>>> getWeather(double lat, double lon) async {
    try {
      final remoteResponse = await _remoteService.fetchWeatherAll(lat, lon);
      return right(
        await remoteResponse.when(
          noConnection: () async => Fresh.no(await _localService.getLastWeatherDto().then((_) => _.toDomain())),
          withNewData: (weatherDto) {
            _localService.cacheWeather(weatherDto);
            return Fresh.yes(weatherDto.toDomain());
          },
        ),
      );
    } on RestApiException catch (e) {
      return left(WeatherFailure.api(e.errorCode));
    }
  }
}
