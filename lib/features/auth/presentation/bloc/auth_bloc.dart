import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/repositories/auth_repository.dart';
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
        onError: (_, stackTrace) => const AuthError(ApiErrorMessages.unknown),
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
        emit(AuthError(_formatErrorMessage(e)));
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
        emit(AuthError(_formatErrorMessage(e)));
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.signOut();
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthError(_formatErrorMessage(e)));
      }
    });
  }

  String _formatErrorMessage(Object error) {
    final String message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    return message;
  }
}
