import 'package:prone/feature/auth/domain/models/user_model.dart';

abstract class AuthRepo {
  Future<UserModel?> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> registerWithEmailPassword({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}
