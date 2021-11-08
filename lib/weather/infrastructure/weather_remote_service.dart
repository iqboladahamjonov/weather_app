import 'package:weather_app/core/infrastucture/remote_response.dart';
import 'package:weather_app/weather/core/infrastructure/weather_api_client.dart';
import 'package:weather_app/weather/core/infrastructure/weather_remote_service_base.dart';
import 'package:weather_app/weather/infrastructure/weather_dto.dart';

abstract class WeatherRemoteService {
  Future<RemoteResponse<WeatherDto>> fetchWeatherAll(double lat, double lon);
  // Future<RemoteResponse<List<DailyWeatherDto>>> fetchDailyWeather(double lat, double lon);
  // Future<RemoteResponse<List<HourlyWeatherDto>>> fetchHourlyWeather(double lat, double lon);
}

class WeatherRemoteServiceImpl extends WeatherRemoteServiceBase implements WeatherRemoteService {
  late WeatherApiClient apiClient;
  WeatherRemoteServiceImpl(apiClient) : super(apiClient);

  @override
  Future<RemoteResponse<WeatherDto>> fetchWeatherAll(double lat, double lon) async => super.fetchWeather(
        lat: lat,
        lon: lon,
        dtoDataSelector: (WeatherDto dto) => dto,
      );

  // @override
  // Future<RemoteResponse<List<DailyWeatherDto>>> fetchDailyWeather(double lat, double lon) async => super.fetchWeather(
  //       lat: lat,
  //       lon: lon,
  //       dtoDataSelector: (WeatherDto dto) => dto.daily,
  //     );

  // @override
  // Future<RemoteResponse<List<HourlyWeatherDto>>> fetchHourlyWeather(double lat, double lon) async => super.fetchWeather(
  //       lat: lat,
  //       lon: lon,
  //       dtoDataSelector: (WeatherDto dto) => dto.hourly,
  //     );

  // @override
  // Future<RemoteResponse<List<HourlyWeatherDto>>> fetchHourlyWeather(double lat, double lon) async {
  //   try {
  //     final response = await apiClient.dio.get('lat=${lat}&lon=${lon}');
  //     if (response.statusCode == 200) {
  //       final WeatherDto weatherDto = WeatherDto.fromJson(response.data as Map<String, dynamic>);
  //       return RemoteResponse.withNewData(weatherDto.hourly);
  //     } else {
  //       throw RestApiException(response.statusCode);
  //     }
  //   } on DioError catch (e) {
  //     if (e.isNoConnectionError) {
  //       return const RemoteResponse.noConnection();
  //     } else if (e.response != null) {
  //       throw RestApiException(e.response?.statusCode);
  //     } else {
  //       rethrow;
  //     }
  //   }
  // }

  // @override
  // Future<RemoteResponse<List<DailyWeatherDto>>> fetchDailyWeather(double lat, double lon) async {
  //   try {
  //     final response = await apiClient.dio.get('lat=${lat}&lon=${lon}');
  //     if (response.statusCode == 200) {
  //       final WeatherDto weatherDto = WeatherDto.fromJson(response.data as Map<String, dynamic>);
  //       return RemoteResponse.withNewData((weatherDto.daily));
  //     } else {
  //       throw RestApiException(response.statusCode);
  //     }
  //   } on DioError catch (e) {
  //     if (e.isNoConnectionError) {
  //       return const RemoteResponse.noConnection();
  //     } else if (e.response != null) {
  //       throw RestApiException(e.response?.statusCode);
  //     } else {
  //       rethrow;
  //     }
  //   }
  // }
}
