class UsernameValidator {
  static const int minLength = 3;
  static const int maxLength = 20;

  // Reserved usernames that cannot be used
  static const List<String> reservedUsernames = [
    'admin',
    'root',
    'api',
    'www',
    'app',
    'support',
    'help',
    'test',
    'prone',
    'poll',
    'quiz',
    'vote',
    'login',
    'register',
    'profile',
    'settings',
    'account',
    'home',
    'about',
    'contact',
    'privacy',
    'terms',
  ];

  /// Validates username format
  /// Returns error message if invalid, null if valid
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kullanıcı adı gerekli';
    }

    // Remove whitespace
    value = value.trim();

    // Check length
    if (value.length < minLength) {
      return 'Kullanıcı adı en az $minLength karakter olmalı';
    }

    if (value.length > maxLength) {
      return 'Kullanıcı adı en fazla $maxLength karakter olabilir';
    }

    // Check format (only lowercase letters, numbers, and underscores)
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(value)) {
      return 'Sadece küçük harf, rakam ve alt çizgi kullanabilirsiniz';
    }

    // Check reserved usernames
    if (reservedUsernames.contains(value.toLowerCase())) {
      return 'Bu kullanıcı adı kullanılamaz';
    }

    // Check if starts or ends with underscore
    if (value.startsWith('_') || value.endsWith('_')) {
      return 'Kullanıcı adı alt çizgi ile başlayamaz veya bitemez';
    }

    // Check consecutive underscores
    if (value.contains('__')) {
      return 'Ardışık alt çizgi kullanılamaz';
    }

    return null; // Valid
  }

  /// Normalizes username by converting to lowercase and removing invalid characters
  static String normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_]'), '') // Remove invalid characters
        .replaceAll(
          RegExp(r'_+'),
          '_',
        ) // Replace multiple underscores with single
        .replaceAll(
          RegExp(r'^_+|_+$'),
          '',
        ); // Remove leading/trailing underscores
  }

  /// Suggests a valid username based on input
  static String suggest(String input) {
    String normalized = normalize(input);

    // Ensure minimum length
    if (normalized.length < minLength) {
      normalized = '${normalized}user'.substring(0, minLength);
    }

    // Ensure maximum length
    if (normalized.length > maxLength) {
      normalized = normalized.substring(0, maxLength);
    }

    // Remove trailing underscore if any
    if (normalized.endsWith('_')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    return normalized;
  }
}
