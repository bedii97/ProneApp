import 'package:supabase_flutter/supabase_flutter.dart';

class AuthErrorHandler {
  /// Converts Supabase AuthException to user-friendly Turkish messages
  static String handleAuthException(AuthException exception) {
    // Handle both string and int status codes
    final statusCode = exception.statusCode?.toString();

    switch (statusCode) {
      case '400':
        if (exception.message.contains('Invalid email')) {
          return 'Geçersiz email formatı';
        } else if (exception.message.contains('Password')) {
          return 'Şifre çok zayıf. En az 6 karakter olmalı';
        } else if (exception.message.contains('User already registered')) {
          return 'Bu email adresi zaten kayıtlı';
        } else if (exception.message.contains('Invalid login credentials')) {
          return 'Email veya şifre hatalı';
        } else if (exception.message.contains('Signup not allowed')) {
          return 'Kayıt işlemi şu anda devre dışı';
        } else if (exception.message.contains('Email not confirmed')) {
          return 'Email adresinizi doğrulayın';
        }
        break;

      case '422':
        if (exception.message.contains('email')) {
          return 'Email adresi geçersiz';
        } else if (exception.message.contains('password')) {
          return 'Şifre geçersiz';
        }
        break;

      case '429':
        return 'Çok fazla deneme yapıldı. Lütfen bir süre bekleyin';

      case '500':
        return 'Sunucu hatası. Lütfen daha sonra tekrar deneyin';

      default:
        // Check specific error messages
        final message = exception.message.toLowerCase();

        if (message.contains('email already registered') ||
            message.contains('user already registered')) {
          return 'Bu email adresi zaten kayıtlı';
        }

        if (message.contains('invalid email')) {
          return 'Geçersiz email formatı';
        }

        if (message.contains('invalid login credentials') ||
            message.contains('invalid credentials')) {
          return 'Email veya şifre hatalı';
        }

        if (message.contains('password')) {
          if (message.contains('weak') || message.contains('short')) {
            return 'Şifre çok zayıf. En az 6 karakter, büyük-küçük harf ve rakam içermeli';
          } else if (message.contains('invalid')) {
            return 'Geçersiz şifre formatı';
          }
        }

        if (message.contains('username')) {
          if (message.contains('already exists') || message.contains('taken')) {
            return 'Bu kullanıcı adı zaten alınmış';
          } else if (message.contains('invalid')) {
            return 'Geçersiz kullanıcı adı formatı';
          }
        }

        if (message.contains('network') || message.contains('connection')) {
          return 'İnternet bağlantısını kontrol edin';
        }

        if (message.contains('timeout')) {
          return 'İşlem zaman aşımına uğradı. Tekrar deneyin';
        }

        if (message.contains('rate limit')) {
          return 'Çok fazla deneme yapıldı. Lütfen bekleyin';
        }

        if (message.contains('email not confirmed')) {
          return 'Email adresinizi doğrulayın';
        }

        if (message.contains('signup disabled')) {
          return 'Kayıt işlemi şu anda devre dışı';
        }
    }

    // Fallback to original message or generic error
    return exception.message.isNotEmpty
        ? exception.message
        : 'Beklenmedik bir hata oluştu';
  }

  /// Handles general exceptions
  static String handleGeneralException(dynamic exception) {
    final message = exception.toString().toLowerCase();

    if (message.contains('socket') ||
        message.contains('network') ||
        message.contains('connection')) {
      return 'İnternet bağlantısını kontrol edin';
    }

    if (message.contains('timeout')) {
      return 'İşlem zaman aşımına uğradı. Tekrar deneyin';
    }

    if (message.contains('format') || message.contains('parse')) {
      return 'Veri formatı hatası. Lütfen tekrar deneyin';
    }

    return 'Beklenmedik bir hata oluştu. Lütfen tekrar deneyin';
  }
}
