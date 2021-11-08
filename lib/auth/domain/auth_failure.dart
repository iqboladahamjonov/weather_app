import 'package:weather_app/core/domain/failures.dart';

class AuthFailure extends Failure {
  final String message;

  AuthFailure(this.message);
}
