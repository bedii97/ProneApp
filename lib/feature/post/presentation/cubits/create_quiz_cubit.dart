import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/core/utils/quiz_validator.dart';
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
    if (validateStep()) {
      emit(state.copyWith(step: state.step + 1, status: FormStatus.initial));
    } else {
      emit(state.copyWith(status: FormStatus.invalid));
    }
  }

  void previousStep() {
    if (state.step > 0) {
      emit(state.copyWith(step: state.step - 1, status: FormStatus.initial));
    }
  }

  // --- Doğrulama ve Adım İlerleme Mantığı ---

  bool validateStep() {
    bool isValid = true;
    isValid = state.step == 0 ? validateStep1() : isValid;
    return isValid;
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

  // TODO: validateStep2(), validateStep3() ...

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
}
