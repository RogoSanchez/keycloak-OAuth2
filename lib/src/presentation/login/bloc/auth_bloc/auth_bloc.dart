import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:keycloack_integrations/src/data/repositories/autentication_repository.dart';
import '../../../../data/model/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthState.unknownState()) {
    on<_AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<_AuthenticationLoginPressed>(_onLoginPressed);
    on<_AuthenticationLogoutPressed>(_onLogoutPressed);
    on<_Initialize>(_onInitialize);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onSubscriptionRequested(
    _AuthenticationSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    await emit.forEach(
      _authenticationRepository.status,
      onData: (AuthenticationStatus status) {
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            return const AuthState.unauthenticated();

          case AuthenticationStatus.authenticated:
            final user = tryGetUser();
            if (user != null) {
              return AuthState.authenticated(user: user);
            }
            return const AuthState.unauthenticated();

          case AuthenticationStatus.unknown:
            return const AuthState.unknownState();

          case AuthenticationStatus.sessionExpired:
            return const AuthState.unauthenticated();
        }
      },
    );
  }

  Future<void> _onInitialize(_Initialize event, Emitter<AuthState> emit) async {
    try {
      await _authenticationRepository.initialize();
      add(AuthEvent.authenticationSubscriptionRequested());
    } catch (e) {
      emit(const AuthState.unknownState());
    }
  }

  UserModel? tryGetUser() {
    final currentUser = _authenticationRepository.currentUser;
    return currentUser;
  }

  Future<void> _onLogoutPressed(
    _AuthenticationLogoutPressed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authenticationRepository.logOut();
    } catch (e) {
      ///
    } finally {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLoginPressed(
    _AuthenticationLoginPressed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authenticationRepository.logInWithBrowser();
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }
  }
}
