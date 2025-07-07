import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/core/utils/quiz_validator.dart';
import 'package:prone/feature/post/domain/models/quiz_result_model.dart';
import 'create_quiz_state.dart';

class CreateQuizCubit extends Cubit<CreateQuizState> {
  // final PostRepo _postRepo; // Son adımda kullanmak için
  CreateQuizCubit() : super(const CreateQuizState());

  // --- Event Metotları (UI'dan çağrılacak) ---

  int get step => state.step;
  bool get hasTimeLimit => state.hasTimeLimit;
  set hasTimeLimit(bool value) {
    emit(state.copyWith(hasTimeLimit: value));
  }

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
        // Süre sınırı kaldırılırsa tarihi temizle
        expiresAt: value ? state.expiresAt : null,
      ),
    );
  }

  void expiresAtChanged(DateTime? value) {
    emit(state.copyWith(expiresAt: value));
  }

  void nextStep() {
    if (state.step < 4 && validateSteps()) {
      // Maximum step kontrolü
      emit(state.copyWith(step: state.step + 1, status: FormStatus.initial));
    } else if (!validateSteps()) {
      emit(state.copyWith(status: FormStatus.invalid));
    }
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

  // --- Doğrulama ve Adım İlerleme Mantığı ---

  // Doğru implementasyon:
  bool validateSteps() {
    switch (state.step) {
      case 0:
        return validateStep1();
      case 1:
        return validateStep2();
      // case 2: return validateStep3(); // Questions step
      // case 3: return validateStep4(); // Scoring step
      default:
        return true;
    }
  }

  bool validateStep1() {
    final titleError = QuizValidator.validateQuizTitle(state.title);
    final descriptionError = QuizValidator.validateQuizDescription(
      state.description,
    );

    final errors = <String, String>{};
    if (titleError != null) errors['title'] = titleError;
    if (descriptionError != null) errors['description'] = descriptionError;

    // Süre sınırı kontrolü
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

    // Hata yoksa temizle
    emit(state.copyWith(validationErrors: {}, status: FormStatus.initial));
    return true;
  }

  Future<void> publishQuiz() async {
    // Tüm adımların validasyonunu tekrar kontrol et...
    if (!validateStep1() /* && !validateStep2() ... */ ) {
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
      // final quizModel = CreateQuizModel(title: state.title, ...);
      // await _postRepo.createQuiz(quizModel);
      await Future.delayed(const Duration(seconds: 2)); // Simülasyon
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

  // Step 2 validation
  bool validateStep2() {
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
}
