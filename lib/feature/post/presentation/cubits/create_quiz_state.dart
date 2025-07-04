enum FormStatus {
  initial,
  validating,
  invalid,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

class CreateQuizState {
  // Adım 1: Temel Bilgiler
  final int step;
  final String title;
  final String description;
  final bool hasTimeLimit;
  final DateTime? expiresAt;

  // TODO: Adım 2, 3, 4 için veriler eklenecek
  // final List<QuestionModel> questions;
  // final List<ResultModel> results;

  // Genel Durum
  final FormStatus status;
  final String? errorMessage;
  // Hangi adımdaki hangi alanın hatalı olduğunu belirtmek için
  final Map<String, String> validationErrors;

  const CreateQuizState({
    this.step = 0,
    this.title = '',
    this.description = '',
    this.hasTimeLimit = false,
    this.expiresAt,
    // this.questions = const [],
    // this.results = const [],
    this.status = FormStatus.initial,
    this.errorMessage,
    this.validationErrors = const {},
  });

  CreateQuizState copyWith({
    int? step,
    String? title,
    String? description,
    bool? hasTimeLimit,
    DateTime? expiresAt,
    // List<QuestionModel>? questions,
    // List<ResultModel>? results,
    FormStatus? status,
    String? errorMessage,
    Map<String, String>? validationErrors,
  }) {
    return CreateQuizState(
      step: step ?? this.step,
      title: title ?? this.title,
      description: description ?? this.description,
      hasTimeLimit: hasTimeLimit ?? this.hasTimeLimit,
      expiresAt: expiresAt ?? this.expiresAt,
      // questions: questions ?? this.questions,
      // results: results ?? this.results,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }
}
