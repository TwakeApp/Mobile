import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twake/models/globals/globals.dart';
import 'package:twake/repositories/authentication_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  late final AuthenticationRepository _repository;
  late final StreamSubscription _networkSubscription;

  AuthenticationCubit({AuthenticationRepository? repository})
      : super(AuthenticationValidation()) {
    if (repository == null) {
      repository = AuthenticationRepository();
    }

    _repository = repository;

    _networkSubscription = Globals.instance.connection.listen((connection) {
      if (connection == Connection.connected) _repository.startTokenValidator();
    });

    checkAuthentication();
  }

  void checkAuthentication() async {
    final authenticated = await _repository.isAuthenticated();

    if (authenticated) {
      emit(AuthenticationSuccess());
    } else {
      emit(AuthenticationInitial());
    }
  }

  void authenticate({
    required String username,
    required String password,
  }) async {
    emit(AuthenticationInProgress());
    final success = await _repository.authenticate(
      username: username,
      password: password,
    );

    if (!success) {
      emit(AuthenticationFailure());
    } else {
      emit(AuthenticationSuccess());
    }
  }

  void logout() {
    _repository.logout();
    emit(AuthenticationInitial());
  }

  @override
  Future<void> close() {
    _networkSubscription.cancel();
    return super.close();
  }
}
