import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/auth/domain/account.dart';
import 'package:weather_app/auth/domain/auth_repository.dart';
import 'package:weather_app/auth/infrastructure/local_service/cache_auth_local_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<WatchAuthChanges>((event, emit) async* {
      await for (Account? account in _authRepository.watchAccountAuthState()) {
        if (account != null) {
          emit(Authenticated(account));
        } else {
          emit(NotAuthenticated());
        }
      }
    });
  }
}
