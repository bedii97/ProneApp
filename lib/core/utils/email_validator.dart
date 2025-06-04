class EmailValidator {
  /// Validates email format
  /// Returns error message if invalid, null if valid
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email adresi gerekli';
    }

    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
      return 'Geçersiz e-posta formatı.';
    }

    return null; // Valid
  }
}
