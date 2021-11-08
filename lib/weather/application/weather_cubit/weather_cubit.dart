import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:weather_app/core/domain/fresh.dart';
import 'package:weather_app/weather/application/location_cubit/location_cubit.dart';
import 'package:weather_app/weather/domain/weather.dart';
import 'package:weather_app/weather/domain/weather_failure.dart';
import 'package:weather_app/weather/domain/weather_repository.dart';

part 'weather_cubit.freezed.dart';
part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _weatherRepository;
  final LocationCubit locationCubit;
  WeatherCubit(
    this._weatherRepository, {
    required this.locationCubit,
  }) : super(WeatherState.initial()) {
    locationCubitSubscription = locationCubit.stream.listen((LocationState state) {
      state.maybeWhen(
        failure: (l) {
          ///if location is disabled, then fetch the weather for default Kiev location
          _refreshWeather(50.450001, 50.450001);
        },
        success: (position) {
          _refreshWeather(position.latitude, position.longitude);
        },
        orElse: () {},
      );
    });
  }
  Future<void> getWeather() async {
    locationCubit.fetchLocation();
  }

  late StreamSubscription locationCubitSubscription;

  _refreshWeather(double lat, double lon) async {
    emit(WeatherState.loading());
    final weatherOrFailure = await _weatherRepository.getWeather(lat, lon);
    emit(weatherOrFailure.fold(
      (l) => WeatherState.failure(l),
      (weather) => WeatherState.success(weather),
    ));
  }
}
