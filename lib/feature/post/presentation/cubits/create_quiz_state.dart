import 'package:prone/feature/post/domain/models/quiz_question_model.dart';

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

  final List<QuizResultModel> results;

  // Adım 2: Sorular
  final List<QuizQuestion> questions;

  // Genel Durum
  final FormStatus status;
  final String? errorMessage;
  final Map<String, String> validationErrors;

  const CreateQuizState({
    this.step = 0,
    this.title = '',
    this.description = '',
    this.hasTimeLimit = false,
    this.expiresAt,
    this.questions = const [],
    this.status = FormStatus.initial,
    this.errorMessage,
    this.validationErrors = const {},
    this.results = const [],
  });

  CreateQuizState copyWith({
    int? step,
    String? title,
    String? description,
    bool? hasTimeLimit,
    DateTime? expiresAt,
    List<QuizQuestion>? questions,
    FormStatus? status,
    String? errorMessage,
    Map<String, String>? validationErrors,
    List<QuizResultModel>? results,
  }) {
    return CreateQuizState(
      step: step ?? this.step,
      title: title ?? this.title,
      description: description ?? this.description,
      hasTimeLimit: hasTimeLimit ?? this.hasTimeLimit,
      expiresAt: expiresAt ?? this.expiresAt,
      questions: questions ?? this.questions,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      validationErrors: validationErrors ?? this.validationErrors,
      results: results ?? this.results,
    );
  }
}
