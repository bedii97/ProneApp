abstract class AuthState {
  const AuthState();
}

// Başlangıç durumu
class AuthInitial extends AuthState {}

// İşlem devam ediyor durumu (Loading)
class AuthLoading extends AuthState {}

// Kullanıcı giriş yapmış durumu
class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;

  const AuthAuthenticated({required this.userId, required this.email});
}

// Kullanıcı giriş yapmamış durumu
class AuthUnauthenticated extends AuthState {}

// İşlem başarısız durumu (Hata mesajı ile birlikte)
class AuthFailure extends AuthState {
  final String message;
  final int instanceId;

  AuthFailure(this.message)
    : instanceId = DateTime.now().millisecondsSinceEpoch;
}
