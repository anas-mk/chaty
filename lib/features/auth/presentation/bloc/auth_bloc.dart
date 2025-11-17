import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entities/user_entity.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/usecases/login.dart';
import '../../data/usecases/logout.dart';
import '../../data/usecases/register.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUsecase;
  final Register registerUsecase;
  final Logout logoutUsecase;
  final AuthRepository repository;

  StreamSubscription<UserEntity?>? _authSub;

  AuthBloc({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.repository,
  }) : super(AuthInitial()) {

    /// Public Events
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<AuthCheckRequested>(_onAuthCheck);

    /// ⭐ لازم Handler للـ _AuthUserChanged
    on<_AuthUserChanged>((event, emit) {
      _handleUser(event.user, emit);
    });

    /// Listen to firebase auth changes
    _authSub = repository.authStateChanges().listen((user) {
      add(_AuthUserChanged(user));
    });
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUsecase(event.email, event.password);
    result.fold(
          (failure) => emit(AuthError("Login failed")),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUsecase( event.name, event.email, event.password);
    result.fold(
          (failure) => emit(AuthError("Register failed")),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await logoutUsecase();
  }

  void _onAuthCheck(AuthCheckRequested event, Emitter<AuthState> emit) {
    emit(AuthLoading());
  }

  /// Internal user handler
  void _handleUser(UserEntity? user, Emitter<AuthState> emit) {
    if (user == null) {
      emit(AuthUnauthenticated());
    } else {
      emit(AuthAuthenticated(user));
    }
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}

/// Internal event (private)
class _AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  _AuthUserChanged(this.user);
}
