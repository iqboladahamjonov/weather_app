import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/auth/domain/account.dart';
import 'package:weather_app/auth/domain/auth_failure.dart';
import 'package:weather_app/auth/domain/auth_repository.dart';
import 'package:weather_app/auth/domain/auth_type.dart';
import 'package:weather_app/auth/infrastructure/account_dto.dart';
import 'package:weather_app/auth/infrastructure/local_service/cache_auth_local_service.dart';
import 'package:weather_app/auth/infrastructure/remote_service/facebook_auth_remote_service.dart';
import 'package:weather_app/auth/infrastructure/remote_service/google_auth_remote_service.dart';
import 'package:weather_app/core/domain/failures.dart';
import 'package:weather_app/core/infrastucture/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleAuthRemoteService _googleAuth;
  final FacebookAuthRemoteService _facebookAuth;
  final FirebaseAuth _firebase;
  final CacheAuthLocalServiceImpl _cachedAuth;

  AuthRepositoryImpl(this._googleAuth, this._facebookAuth, this._firebase, this._cachedAuth);

  @override
  Future<Either<AuthFailure, Account>> login(AuthMethod authMethod) async {
    try {
      switch (authMethod) {
        case AuthMethod.google:
          final googleAuthResponse = await _googleAuth.login();
          final AccountDto accountDto = AccountDto.fromUser(googleAuthResponse.user!);
          _cachedAuth.cacheAccount(accountDto);
          return right(accountDto.toDomain());
        case AuthMethod.facebook:
          throw UnimplementedError();
        default:
          throw UnimplementedError();
      }
    } on AuthException {
      return left(AuthFailure('Firebase Auth Failure'));
    } catch (e) {
      return left(UnknownFailure() as AuthFailure);
    }
  }

  @override
  Future<void> logout(AuthMethod unAuthMethod) async {
    switch (unAuthMethod) {
      case AuthMethod.google:
        await _cachedAuth.removeLastCachedAccount();
        return await _googleAuth.logout();
      case AuthMethod.facebook:
        return await _facebookAuth.logout();
      default:
        throw UnimplementedError();
    }
  }

  @override
  Stream<Account?> watchAccountAuthState() async* {
    final firebaseUserState = await _firebase.authStateChanges();
    yield* firebaseUserState.map((userEvent) => AccountDto.fromUser(userEvent).toDomain());
  }
}
    // await for (var user in _firebase.authStateChanges()) {
    //   if (user != null) {
    //     yield* 
    //   } else {
    //     emit(NotAuthenticated());
    //   }
    // }