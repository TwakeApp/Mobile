import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twake/events/auth_event.dart';
import 'package:twake/repositories/auth_repository.dart';
import 'package:twake/services/api.dart';
import 'package:twake/services/init.dart';
import 'package:twake/states/auth_state.dart';

export 'package:twake/events/auth_event.dart';
export 'package:twake/states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  AuthBloc(this.repository) : super(AuthInitializing()) {
    // setting callback to notify the bloc in case if token will expire
    Api().resetAuthentication = resetAuthentication;
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthInitialize) {
      switch (repository.tokenIsValid()) {
        case TokenStatus.Valid:
          final InitData initData = await initMain();
          yield Authenticated(initData);
          break;
        case TokenStatus.AccessExpired:
          switch (await repository.prolongToken()) {
            case AuthResult.Ok:
              final InitData initData = await initMain();
              yield Authenticated(initData);
              break;
            case AuthResult.NetworkError:
              // TODO Work out the case with absent network connection
              final InitData initData = await initMain();
              yield Authenticated(initData);
              break;
            case AuthResult.WrongCredentials:
              yield Unauthenticated();
          }
          break;
        case TokenStatus.BothExpired:
          yield Unauthenticated();
      }
    } else if (event is Authenticate) {
      yield Authenticating();
      final result = await repository.authenticate(
        username: event.username,
        password: event.password,
      );
      if (result == AuthResult.WrongCredentials) {
        yield Unauthenticated();
      } else if (result == AuthResult.NetworkError) {
        yield AuthenticationError();
      } else {
        final InitData initData = await initMain();
        yield Authenticated(initData);
      }
    } else if (event is ResetAuthentication) {
      yield Unauthenticated(message: 'Session has expired');
    }
  }

  void resetAuthentication() {
    this.add(ResetAuthentication());
  }
}
