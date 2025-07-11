import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'package:prone/feature/post/domain/models/quiz_result_model.dart';
import 'package:prone/feature/post/domain/models/quiz_scoring_model.dart';

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
  final List<QuizScoringModel> scoring;

  // Adım 2: Sorular
  final List<QuizQuestionModel> questions;

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
    this.scoring = const [],
  });

  CreateQuizState copyWith({
    int? step,
    String? title,
    String? description,
    bool? hasTimeLimit,
    DateTime? expiresAt,
    List<QuizQuestionModel>? questions,
    FormStatus? status,
    String? errorMessage,
    Map<String, String>? validationErrors,
    List<QuizResultModel>? results,
    List<QuizScoringModel>? scoring,
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
      scoring: scoring ?? this.scoring,
    );
  }

  QuizScoringModel? getScoringForOption(String questionId, String optionId) {
    try {
      return scoring.firstWhere(
        (s) => s.questionId == questionId && s.optionId == optionId,
      );
    } catch (e) {
      return null;
    }
  }

  int getTotalPointsForResult(String resultId) {
    int total = 0;
    for (var scoring in this.scoring) {
      total += scoring.resultPoints[resultId] ?? 0;
    }
    return total;
  }
}
