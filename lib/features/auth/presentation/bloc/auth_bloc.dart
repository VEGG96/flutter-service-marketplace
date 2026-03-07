import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      emit(AuthLoading());
      await emit.forEach(
        _authRepository.currentUser,
        onData: (user) {
          if (user != null) return Authenticated(user);
          return Unauthenticated();
        },
        onError: (_, stackTrace) =>
            const AuthError('Error checking auth status'),
      );
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.signIn(
          email: event.email,
          password: event.password,
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.signUp(
          email: event.email,
          password: event.password,
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      await _authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}
