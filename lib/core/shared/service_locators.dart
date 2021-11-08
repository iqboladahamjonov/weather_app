import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/auth/shared/auth_provider.dart';
import 'package:weather_app/weather/core/shared/providers.dart';

final getIt = GetIt.instance;
Future<void> init() async {
  await authProvider();
  await weatherProvider();

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => Dio());
}
