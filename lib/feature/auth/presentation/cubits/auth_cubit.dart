import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/auth/domain/repos/auth_repo.dart';
import 'package:prone/feature/auth/presentation/cubits/auth_state.dart'
    as app_auth;
import 'package:prone/feature/auth/utils/auth_error_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCubit extends Cubit<app_auth.AuthState> {
  final AuthRepo _authService;

  AuthCubit(this._authService) : super(app_auth.AuthInitial());

  // Check authentication status on app start
  Future<void> checkAuthStatus() async {
    emit(app_auth.AuthLoading());
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        emit(app_auth.AuthAuthenticated(userId: user.id, email: user.email));
      } else {
        emit(app_auth.AuthUnauthenticated());
      }
    } catch (e) {
      emit(app_auth.AuthUnauthenticated());
    }
  }

  // Login İşlemi
  Future<void> login(String email, String password) async {
    emit(app_auth.AuthLoading());
    try {
      await _authService.loginWithEmailPassword(
        email: email,
        password: password,
      );
      final user = await _authService.getCurrentUser();
      if (user != null) {
        emit(app_auth.AuthAuthenticated(userId: user.id, email: user.email));
      } else {
        emit(app_auth.AuthFailure('Giriş yapılamadı. Lütfen tekrar deneyin.'));
      }
    } on AuthException catch (e) {
      final userFriendlyMessage = AuthErrorHandler.handleAuthException(e);
      emit(app_auth.AuthFailure(userFriendlyMessage));
    } catch (e) {
      final userFriendlyMessage = AuthErrorHandler.handleGeneralException(e);
      emit(app_auth.AuthFailure(userFriendlyMessage));
    }
  }

  // Register İşlemi
  Future<void> register(String email, String password, String username) async {
    emit(app_auth.AuthLoading()); // İşlem başlıyor

    try {
      await _authService.registerWithEmailPassword(
        email: email,
        password: password,
        username: username,
      );

      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        emit(
          app_auth.AuthAuthenticated(userId: user.id, email: user.email ?? ''),
        );
      } else {
        // Kullanıcı null ise bu bir hata durumudur
        emit(app_auth.AuthFailure('Kayıt yapılamadı. Lütfen tekrar deneyin.'));
      }
    } on AuthException catch (e) {
      final userFriendlyMessage = AuthErrorHandler.handleAuthException(e);
      emit(app_auth.AuthFailure(userFriendlyMessage));
    } catch (e) {
      // Diğer olası hatalar (network, format vs.)
      final userFriendlyMessage = AuthErrorHandler.handleGeneralException(e);
      emit(app_auth.AuthFailure(userFriendlyMessage));
    }
  }

  // Sign out
  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      emit(app_auth.AuthUnauthenticated());
    } on AuthException catch (e) {
      final userFriendlyMessage = AuthErrorHandler.handleAuthException(e);
      emit(app_auth.AuthFailure(userFriendlyMessage));
    } catch (e) {
      final userFriendlyMessage = AuthErrorHandler.handleGeneralException(e);

      emit(app_auth.AuthFailure(userFriendlyMessage));
    }
  }

  // İsteğe bağlı: State'i başlangıç durumuna döndürmek için
  void reset() {
    emit(app_auth.AuthInitial());
  }
}
