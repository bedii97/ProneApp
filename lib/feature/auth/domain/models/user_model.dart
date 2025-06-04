import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class UserModel {
  final String id;
  final String username;
  final String email;

  UserModel({required this.id, required this.username, required this.email});

  @override
  String toString() {
    return 'UserModel{id: $id, name: $username, email: $email}';
  }

  factory UserModel.fromSupabaseUser(
    supabase.User supabaseUser, {
    Map<String, dynamic>? profileData,
  }) {
    return UserModel(
      id: supabaseUser.id,
      email:
          supabaseUser.email ??
          '', // Supabase email null olabilir mi? Kontrol edin.
      username: profileData?['username'] as String? ?? "",
    );
  }
}
