import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/core/utils/quiz_validator.dart';
import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'package:prone/feature/post/domain/models/quiz_result_model.dart';
import 'package:prone/feature/post/domain/models/quiz_scoring_model.dart';
import 'create_quiz_state.dart';

class CreateQuizCubit extends Cubit<CreateQuizState> {
  CreateQuizCubit()
    : super(
        CreateQuizState(
          questions: [
            QuizQuestionModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(), // ✅ ID ekle
              questionText: '',
              options: ['', ''], // ✅ En az 2 boş seçenek
            ),
          ],
        ),
      );

  int get step => state.step;
  bool get hasTimeLimit => state.hasTimeLimit;

  void titleChanged(String value) {
    emit(state.copyWith(title: value));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void hasTimeLimitChanged(bool value) {
    emit(
      state.copyWith(
        hasTimeLimit: value,
        expiresAt: value ? state.expiresAt : null,
      ),
    );
  }

  void expiresAtChanged(DateTime? value) {
    emit(state.copyWith(expiresAt: value));
  }

  String _generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 997) % 1000000; // Simple hash
    return '${timestamp}_$random';
  }

  // Soru yönetimi
  void addQuestion() {
    final newQuestion = QuizQuestionModel(
      id: _generateUniqueId(),
      questionText: '',
      options: ['', ''],
    );

    final updatedQuestions = [...state.questions, newQuestion];
    emit(state.copyWith(questions: updatedQuestions));
  }

  void removeQuestion(int index) {
    if (state.questions.length > 1) {
      final updatedQuestions = List<QuizQuestionModel>.from(state.questions)
        ..removeAt(index);
      emit(state.copyWith(questions: updatedQuestions));
    }
  }

  void updateQuestionText(int index, String text) {
    final updatedQuestions = List<QuizQuestionModel>.from(state.questions);
    updatedQuestions[index] = updatedQuestions[index].copyWith(
      questionText: text,
    );
    emit(state.copyWith(questions: updatedQuestions));
  }

  void addOption(int questionIndex) {
    final updatedQuestions = List<QuizQuestionModel>.from(state.questions);
    final options = List<String>.from(updatedQuestions[questionIndex].options)
      ..add('');
    updatedQuestions[questionIndex] = updatedQuestions[questionIndex].copyWith(
      options: options,
    );
    emit(state.copyWith(questions: updatedQuestions));
  }

  void removeOption(int questionIndex, int optionIndex) {
    final updatedQuestions = List<QuizQuestionModel>.from(state.questions);
    final options = List<String>.from(updatedQuestions[questionIndex].options);
    if (options.length > 1) {
      options.removeAt(optionIndex);
      updatedQuestions[questionIndex] = updatedQuestions[questionIndex]
          .copyWith(options: options);
      emit(state.copyWith(questions: updatedQuestions));
    }
  }

  void updateOption(int questionIndex, int optionIndex, String value) {
    final updatedQuestions = List<QuizQuestionModel>.from(state.questions);
    final options = List<String>.from(updatedQuestions[questionIndex].options);
    options[optionIndex] = value;
    updatedQuestions[questionIndex] = updatedQuestions[questionIndex].copyWith(
      options: options,
    );
    emit(state.copyWith(questions: updatedQuestions));
  }

  void previousStep() {
    if (state.step > 0) {
      emit(
        state.copyWith(
          step: state.step - 1,
          status: FormStatus.initial,
          validationErrors: {}, // Geriye giderken hataları temizle
        ),
      );
    }
  }

  // --- Doğrulama Mantığı ---
  void nextStep() {
    if (!validateCurrentStep()) {
      return;
    }

    if (state.step < 4) {
      emit(
        state.copyWith(
          step: state.step + 1,
          status: FormStatus.initial,
          validationErrors: {},
        ),
      );
    }
  }

  // ✅ Ana validation method - tüm step'ler için
  bool validateCurrentStep() {
    switch (state.step) {
      case 0:
        return validateStep1(); // Basic Info
      case 1:
        return validateStep2(); // Questions
      case 2:
        return validateStep3(); // Results
      case 3:
        return validateStep4(); // Scoring
      case 4:
        return validateStep5(); // Preview
      default:
        return true;
    }
  }

  bool _validateAllSteps() {
    return validateStep1() &&
        validateStep2() &&
        validateStep3() &&
        validateStep4() &&
        validateStep5();
  }

  bool validateStep1() {
    final titleError = QuizValidator.validateQuizTitle(state.title);
    final descriptionError = QuizValidator.validateQuizDescription(
      state.description,
    );

    final errors = <String, String>{};
    if (titleError != null) errors['title'] = titleError;
    if (descriptionError != null) errors['description'] = descriptionError;

    if (state.hasTimeLimit && state.expiresAt == null) {
      errors['expiresAt'] = 'Lütfen bitiş tarihi ve saati seçin';
    } else if (state.hasTimeLimit &&
        state.expiresAt != null &&
        state.expiresAt!.isBefore(DateTime.now())) {
      errors['expiresAt'] = 'Bitiş tarihi gelecekte olmalıdır';
    }

    if (errors.isNotEmpty) {
      emit(
        state.copyWith(validationErrors: errors, status: FormStatus.invalid),
      );
      return false;
    }

    emit(state.copyWith(validationErrors: {}, status: FormStatus.initial));
    return true;
  }

  bool validateStep2() {
    final errors = <String, String>{};

    // En az bir soru olmalı
    if (state.questions.isEmpty) {
      errors['questions'] = 'En az bir soru eklemelisiniz';
      emit(
        state.copyWith(validationErrors: errors, status: FormStatus.invalid),
      );
      return false;
    }

    // Her soruyu doğrula
    for (int i = 0; i < state.questions.length; i++) {
      final question = state.questions[i];

      // Soru metni doğrulama
      final questionError = QuizValidator.validateQuizQuestion(
        question.questionText,
      );
      if (questionError != null) {
        errors['question_$i'] = 'Soru ${i + 1}: $questionError';
      }

      // En az 2 seçenek olmalı
      final validOptions = question.options
          .where((option) => option.trim().isNotEmpty)
          .toList();
      if (validOptions.length < 2) {
        errors['question_${i}_options'] =
            'Soru ${i + 1}: En az 2 seçenek gereklidir';
      }

      // Her seçeneği doğrula
      for (int j = 0; j < question.options.length; j++) {
        final optionError = QuizValidator.validateQuizOption(
          question.options[j],
        );
        if (optionError != null && question.options[j].isNotEmpty) {
          errors['question_${i}_option_$j'] =
              'Soru ${i + 1}, Seçenek ${j + 1}: $optionError';
        }
      }
    }

    if (errors.isNotEmpty) {
      emit(
        state.copyWith(validationErrors: errors, status: FormStatus.invalid),
      );
      return false;
    }

    emit(state.copyWith(validationErrors: {}, status: FormStatus.initial));
    return true;
  }

  bool validateStep3() {
    final hasEnoughResults = state.results.length >= 2;
    final hasValidResults = state.results.every(
      (r) => r.title.trim().isNotEmpty && r.description.trim().isNotEmpty,
    );

    final errors = <String, String>{};
    if (!hasEnoughResults) {
      errors['results'] = 'En az 2 sonuç gereklidir';
    }
    if (!hasValidResults) {
      errors['results'] = 'Tüm sonuçların başlık ve açıklaması doldurulmalıdır';
    }

    if (errors.isNotEmpty) {
      emit(
        state.copyWith(validationErrors: errors, status: FormStatus.invalid),
      );
      return false;
    }

    emit(state.copyWith(validationErrors: {}, status: FormStatus.initial));
    return true;
  }

  bool validateStep4() {
    // Scoring validation
    final errors = <String, String>{};

    // Her soru için scoring kontrol et
    for (int i = 0; i < state.questions.length; i++) {
      final question = state.questions[i];
      bool hasScoring = false;

      for (final scoring in state.scoring) {
        if (scoring.questionId == question.id) {
          hasScoring = true;
          break;
        }
      }

      if (!hasScoring) {
        errors['scoring_$i'] = 'Soru ${i + 1} için puan sistemi tanımlanmamış';
      }
    }

    if (errors.isNotEmpty) {
      emit(
        state.copyWith(validationErrors: errors, status: FormStatus.invalid),
      );
      return false;
    }

    return true;
  }

  bool validateStep5() {
    // Preview için özel validation gerekirse
    return true;
  }

  Future<void> publishQuiz() async {
    if (!_validateAllSteps()) {
      emit(
        state.copyWith(
          status: FormStatus.submissionFailure,
          errorMessage: "Lütfen tüm adımlardaki eksikleri giderin.",
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormStatus.submissionInProgress));
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: FormStatus.submissionSuccess));
    } catch (e) {
      emit(
        state.copyWith(
          status: FormStatus.submissionFailure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  //Quiz Results Management
  // Results management
  void addResult(QuizResultModel result) {
    final updatedResults = [...state.results, result];
    emit(state.copyWith(results: updatedResults));
  }

  void addResultFromTemplate(Map<String, dynamic> template) {
    final result = QuizResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: template['title'] ?? '',
      description: template['description'] ?? '',
      icon: template['icon'] ?? 'emoji_events',
      colorValue: template['colorValue'] ?? '#FFFFFF', // Default color
    );
    addResult(result);
  }

  void updateResult(int index, QuizResultModel updatedResult) {
    if (index >= 0 && index < state.results.length) {
      final updatedResults = [...state.results];
      updatedResults[index] = updatedResult;
      emit(state.copyWith(results: updatedResults));
    }
  }

  void removeResult(int index) {
    if (index >= 0 && index < state.results.length) {
      final updatedResults = [...state.results];
      updatedResults.removeAt(index);
      emit(state.copyWith(results: updatedResults));
    }
  }

  void duplicateResult(int index) {
    if (index >= 0 && index < state.results.length) {
      final original = state.results[index];
      final duplicate = original.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '${original.title} (kopya)',
      );
      addResult(duplicate);
    }
  }

  //Scoring Management Methods
  void updateScoring(
    String questionId,
    String optionId,
    String resultId,
    int points,
  ) {
    final updatedScoring = List<QuizScoringModel>.from(state.scoring);

    // Find existing scoring or create new one
    final existingIndex = updatedScoring.indexWhere(
      (s) => s.questionId == questionId && s.optionId == optionId,
    );

    if (existingIndex != -1) {
      // Update existing scoring
      final existing = updatedScoring[existingIndex];
      final updatedResultPoints = Map<String, int>.from(existing.resultPoints);
      updatedResultPoints[resultId] = points;

      updatedScoring[existingIndex] = QuizScoringModel(
        questionId: existing.questionId,
        optionId: existing.optionId,
        resultPoints: updatedResultPoints,
      );
    } else {
      // Create new scoring
      final newScoring = QuizScoringModel(
        questionId: questionId,
        optionId: optionId,
        resultPoints: {resultId: points},
      );
      updatedScoring.add(newScoring);
    }

    emit(state.copyWith(scoring: updatedScoring));
  }

  void autoFillScoring() {
    final updatedScoring = <QuizScoringModel>[];

    for (int qIndex = 0; qIndex < state.questions.length; qIndex++) {
      final question = state.questions[qIndex];

      for (int oIndex = 0; oIndex < question.options.length; oIndex++) {
        final optionId = 'option_${qIndex}_$oIndex'; // Option ID pattern
        final resultPoints = <String, int>{};

        // Simple auto-fill logic: diagonal pattern
        for (int rIndex = 0; rIndex < state.results.length; rIndex++) {
          final resultId = state.results[rIndex].id;

          // Give higher points to matching indices, lower to adjacent
          final points = (oIndex == rIndex)
              ? 5
              : (oIndex == rIndex + 1 || oIndex == rIndex - 1)
              ? 2
              : 0;

          resultPoints[resultId] = points;
        }

        final scoring = QuizScoringModel(
          questionId: question.id,
          optionId: optionId,
          resultPoints: resultPoints,
        );

        updatedScoring.add(scoring);
      }
    }

    emit(state.copyWith(scoring: updatedScoring));
  }

  void clearAllScoring() {
    emit(state.copyWith(scoring: []));
  }

  void clearQuestionScoring(String questionId) {
    final updatedScoring = state.scoring
        .where((s) => s.questionId != questionId)
        .toList();

    emit(state.copyWith(scoring: updatedScoring));
  }
}
