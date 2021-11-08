import 'package:dartz/dartz.dart';
import 'package:weather_app/auth/domain/auth_failure.dart';
import 'package:weather_app/auth/domain/auth_type.dart';

import 'account.dart';

abstract class AuthRepository {
  Stream<Account?> watchAccountAuthState();
  Future<Either<AuthFailure, Account>> login(AuthMethod authMethod);
  Future<void> logout(AuthMethod unAuthMethod);
}
