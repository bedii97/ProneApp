class PasswordValidator {
  static const int minLength = 6;
  static const int maxLength = 30;

  /// Validates username format
  /// Returns error message if invalid, null if valid
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Remove whitespace
    value = value.trim();

    // Check length
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }

    if (value.length > maxLength) {
      return 'Password must be at most $maxLength characters long';
    }

    return null; // Valid
  }
}
