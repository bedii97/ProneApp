import 'package:prone/feature/auth/domain/models/user_model.dart';
import 'package:prone/feature/auth/domain/repos/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepo extends AuthRepo {
  final _supabase = Supabase.instance.client;
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = _supabase.auth.currentUser;

      if (currentUser == null) {
        return null;
      }

      return UserModel(
        id: currentUser.id,
        email: currentUser.email ?? "",
        username: currentUser.userMetadata?['username'] ?? "",
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final deneme = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return UserModel(
        id: deneme.user?.id ?? "",
        email: deneme.user?.email ?? "",
        username: deneme.user?.userMetadata?['username'] ?? "",
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() {
    return _supabase.auth.signOut();
  }

  @override
  Future<UserModel?> registerWithEmailPassword({
    required String username,
    required String email,
    required String password,
  }) {
    try {
      _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      return getCurrentUser();
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to ensure user profile exists in public.users table
  @Deprecated('Not used in the current implementation')
  // ignore: unused_element
  Future<void> _ensureUserProfile(User? user) async {
    if (user == null) return;
    try {
      await _supabase.from('users').upsert({
        'id': user.id,
        'email': user.email,
        'username': user.userMetadata?['username'] ?? "",
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Don't rethrow - this is not critical for login
    }
  }
}
