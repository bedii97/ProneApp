import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/core/utils/quiz_validator.dart';
import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'create_quiz_state.dart';

class CreateQuizCubit extends Cubit<CreateQuizState> {
  CreateQuizCubit() : super(CreateQuizState(questions: [QuizQuestion()]));

  // --- Event Metotları (UI'dan çağrılacak) ---

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

  // Soru yönetimi
  void addQuestion() {
    final updatedQuestions = List<QuizQuestion>.from(state.questions)
      ..add(QuizQuestion());
    emit(state.copyWith(questions: updatedQuestions));
  }

  void removeQuestion(int index) {
    if (state.questions.length > 1) {
      final updatedQuestions = List<QuizQuestion>.from(state.questions)
        ..removeAt(index);
      emit(state.copyWith(questions: updatedQuestions));
    }
  }

  void updateQuestionText(int index, String text) {
    final updatedQuestions = List<QuizQuestion>.from(state.questions);
    updatedQuestions[index] = updatedQuestions[index].copyWith(
      questionText: text,
    );
    emit(state.copyWith(questions: updatedQuestions));
  }

  void addOption(int questionIndex) {
    final updatedQuestions = List<QuizQuestion>.from(state.questions);
    final options = List<String>.from(updatedQuestions[questionIndex].options)
      ..add('');
    updatedQuestions[questionIndex] = updatedQuestions[questionIndex].copyWith(
      options: options,
    );
    emit(state.copyWith(questions: updatedQuestions));
  }

  void removeOption(int questionIndex, int optionIndex) {
    final updatedQuestions = List<QuizQuestion>.from(state.questions);
    final options = List<String>.from(updatedQuestions[questionIndex].options);
    if (options.length > 1) {
      options.removeAt(optionIndex);
      updatedQuestions[questionIndex] = updatedQuestions[questionIndex]
          .copyWith(options: options);
      emit(state.copyWith(questions: updatedQuestions));
    }
  }

  void updateOption(int questionIndex, int optionIndex, String value) {
    final updatedQuestions = List<QuizQuestion>.from(state.questions);
    final options = List<String>.from(updatedQuestions[questionIndex].options);
    options[optionIndex] = value;
    updatedQuestions[questionIndex] = updatedQuestions[questionIndex].copyWith(
      options: options,
    );
    emit(state.copyWith(questions: updatedQuestions));
  }

  void nextStep() {
    if (validateCurrentStep()) {
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

  // --- Doğrulama Mantığı ---

  bool validateCurrentStep() {
    switch (state.step) {
      case 0:
        return validateStep1();
      case 1:
        return validateStep2();
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

  Future<void> publishQuiz() async {
    if (!validateStep1() || !validateStep2()) {
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
}
