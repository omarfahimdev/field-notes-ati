import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/app_exception.dart';
import '../data/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthDemoRequested>(_onDemo);
    on<AuthLogoutRequested>(_onLogout);
  }
  final AuthRepository _repo;

  void _onStarted(AuthStarted e, Emitter<AuthState> emit) {
    emit(_repo.isLoggedIn ? AuthAuthenticated(_repo.currentUser ?? {}) : AuthUnauthenticated());
  }

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repo.login(email: e.email, password: e.password);
      emit(AuthAuthenticated(_repo.currentUser ?? {}));
    } on AppException catch (err) {
      emit(AuthFailure(err.message));
      emit(AuthUnauthenticated());
    } catch (_) {
      emit(const AuthFailure('Login failed'));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onRegister(AuthRegisterRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repo.register(name: e.name, email: e.email, password: e.password);
      emit(AuthAuthenticated(_repo.currentUser ?? {}));
    } on AppException catch (err) {
      emit(AuthFailure(err.message));
      emit(AuthUnauthenticated());
    } catch (_) {
      emit(const AuthFailure('Registration failed'));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onDemo(AuthDemoRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _repo.loginDemo();
    emit(AuthAuthenticated(_repo.currentUser ?? {}));
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    await _repo.logout();
    emit(AuthUnauthenticated());
  }
}
