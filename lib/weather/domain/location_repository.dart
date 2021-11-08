import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/weather/domain/location_failure.dart';

abstract class LocationRepository {
  Future<Either<LocationFailure, Position>> determineLocation();
}
