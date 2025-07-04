class QuizValidator {
  // Quiz Title Validator
  static String? validateQuizTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quiz başlığı gereklidir';
    }
    if (value.trim().length < 3) {
      return 'Quiz başlığı en az 3 karakter olmalıdır';
    }
    if (value.trim().length > 100) {
      return 'Quiz başlığı en fazla 100 karakter olabilir';
    }
    return null;
  }

  // Quiz Description Validator
  static String? validateQuizDescription(String? value) {
    if (value != null && value.trim().isNotEmpty && value.trim().length < 10) {
      return 'Açıklama en az 10 karakter olmalıdır';
    }
    if (value != null && value.trim().length > 500) {
      return 'Açıklama en fazla 500 karakter olabilir';
    }
    return null;
  }

  // Quiz Question Validator
  static String? validateQuizQuestion(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Soru metni gereklidir';
    }
    if (value.trim().length < 5) {
      return 'Soru en az 5 karakter olmalıdır';
    }
    if (value.trim().length > 200) {
      return 'Soru en fazla 200 karakter olabilir';
    }
    return null;
  }

  // Quiz Option Validator
  static String? validateQuizOption(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Seçenek metni gereklidir';
    }
    if (value.trim().isEmpty) {
      return 'Seçenek en az 1 karakter olmalıdır';
    }
    if (value.trim().length > 100) {
      return 'Seçenek en fazla 100 karakter olabilir';
    }
    return null;
  }

  // Quiz Result Title Validator
  static String? validateQuizResultTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Sonuç başlığı gereklidir';
    }
    if (value.trim().length < 3) {
      return 'Sonuç başlığı en az 3 karakter olmalıdır';
    }
    if (value.trim().length > 50) {
      return 'Sonuç başlığı en fazla 50 karakter olabilir';
    }
    return null;
  }

  // Quiz Result Description Validator
  static String? validateQuizResultDescription(String? value) {
    if (value != null && value.trim().isNotEmpty && value.trim().length < 10) {
      return 'Sonuç açıklaması en az 10 karakter olmalıdır';
    }
    if (value != null && value.trim().length > 300) {
      return 'Sonuç açıklaması en fazla 300 karakter olabilir';
    }
    return null;
  }

  // URL Validator (for result images)
  static String? validateImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlPattern.hasMatch(value.trim())) {
      return 'Geçerli bir URL giriniz';
    }
    return null;
  }
}
