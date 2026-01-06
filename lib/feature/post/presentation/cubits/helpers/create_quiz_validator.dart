import 'dart:developer';

import 'package:prone/core/utils/quiz_validator.dart';
import '../create_quiz_state.dart';

class ValidationResult {
  final bool isValid;
  final Map<String, String> errors;

  const ValidationResult({required this.isValid, required this.errors});

  factory ValidationResult.success() {
    return const ValidationResult(isValid: true, errors: {});
  }

  factory ValidationResult.error(Map<String, String> errors) {
    return ValidationResult(isValid: false, errors: errors);
  }
}

class CreateQuizValidator {
  /// Ana validation method - mevcut step'i validate eder
  static ValidationResult validateCurrentStep(CreateQuizState state) {
    switch (state.step) {
      case 0:
        return validateBasicInfo(state);
      case 1:
        return validateQuestions(state);
      case 2:
        return validateResults(state);
      case 3:
        return validateScoring(state);
      case 4:
        return validatePreview(state);
      default:
        return ValidationResult.success();
    }
  }

  /// Tüm step'leri validate eder
  static bool validateAllSteps(CreateQuizState state) {
    for (int step = 0; step <= 4; step++) {
      final tempState = state.copyWith(step: step);
      final result = validateCurrentStep(tempState);
      if (!result.isValid) {
        return false;
      }
    }
    return true;
  }

  /// Step 1: Temel bilgileri validate eder
  static ValidationResult validateBasicInfo(CreateQuizState state) {
    final errors = <String, String>{};

    // Title validation
    final titleError = QuizValidator.validateQuizTitle(state.title);
    if (titleError != null) {
      errors['title'] = titleError;
    }

    // Description validation (opsiyonel ama varsa validate et)
    if (state.description.isNotEmpty) {
      final descriptionError = QuizValidator.validateQuizDescription(
        state.description,
      );
      if (descriptionError != null) {
        errors['description'] = descriptionError;
      }
    }

    // Time limit validation
    if (state.hasTimeLimit) {
      if (state.expiresAt == null) {
        errors['expiresAt'] = 'Lütfen bitiş tarihi ve saati seçin';
      } else if (state.expiresAt!.isBefore(DateTime.now())) {
        errors['expiresAt'] = 'Bitiş tarihi gelecekte olmalıdır';
      }
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.error(errors);
  }

  /// Step 2: Soruları validate eder
  static ValidationResult validateQuestions(CreateQuizState state) {
    final errors = <String, String>{};

    if (state.questions.isEmpty) {
      errors['questions'] = 'En az 1 soru eklemelisiniz';
      return ValidationResult.error(errors);
    }

    // Her soruyu validate et
    for (int i = 0; i < state.questions.length; i++) {
      final question = state.questions[i];

      // Soru metni kontrolü
      if (question.questionText.trim().isEmpty) {
        errors['question_$i'] = '${i + 1}. sorunun metnini girin';
      }

      // Seçenekler kontrolü
      final nonEmptyOptions = question.options
          .where((option) => option.text.trim().isNotEmpty)
          .toList();

      if (nonEmptyOptions.length < 2) {
        errors['question_${i}_options'] =
            '${i + 1}. soru için en az 2 seçenek girmelisiniz';
      }

      // Seçenek tekrarı kontrolü
      final uniqueOptions = nonEmptyOptions.toSet();
      if (uniqueOptions.length != nonEmptyOptions.length) {
        errors['question_${i}_duplicate'] =
            '${i + 1}. soruda aynı seçenekler var';
      }
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.error(errors);
  }

  /// Step 3: Sonuçları validate eder
  static ValidationResult validateResults(CreateQuizState state) {
    final errors = <String, String>{};

    if (state.results.isEmpty) {
      errors['results'] = 'En az 1 sonuç eklemelisiniz';
      return ValidationResult.error(errors);
    }

    if (state.results.length < 2) {
      errors['results'] = 'En az 2 sonuç eklemelisiniz';
      return ValidationResult.error(errors);
    }

    // Her sonucu validate et
    for (int i = 0; i < state.results.length; i++) {
      final result = state.results[i];

      if (result.title.trim().isEmpty) {
        errors['result_${i}_title'] = '${i + 1}. sonucun başlığını girin';
      }

      if (result.description.trim().isEmpty) {
        errors['result_${i}_description'] =
            '${i + 1}. sonucun açıklamasını girin';
      }
    }

    // Sonuç başlık tekrarı kontrolü
    final titles = state.results
        .map((r) => r.title.trim().toLowerCase())
        .where((title) => title.isNotEmpty)
        .toList();

    final uniqueTitles = titles.toSet();
    if (uniqueTitles.length != titles.length) {
      errors['results_duplicate'] = 'Sonuç başlıkları farklı olmalıdır';
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.error(errors);
  }

  /// Step 4: Puanlama sistemini validate eder
  static ValidationResult validateScoring(CreateQuizState state) {
    final errors = <String, String>{};

    if (state.scoring.isEmpty) {
      errors['scoring'] = 'Puanlama sistemini tamamlamanız gerekiyor';
      return ValidationResult.error(errors);
    }

    // Her soru ve seçenek için puanlama kontrolü
    for (
      int questionIndex = 0;
      questionIndex < state.questions.length;
      questionIndex++
    ) {
      final question = state.questions[questionIndex];

      for (
        int optionIndex = 0;
        optionIndex < question.options.length;
        optionIndex++
      ) {
        final optionText = question.options[optionIndex].text;
        if (optionText.trim().isEmpty) continue;

        final optionId = 'option_${questionIndex}_$optionIndex';

        // Bu seçenek için scoring var mı?
        final scoring = state.scoring.firstWhere(
          (s) => s.questionId == question.id && s.optionId == optionId,
          orElse: () => throw StateError('Scoring not found'),
        );

        // Her result için puan verilmiş mi?
        //Todo: 0 puan verilmiş seçeneklere izin vermiyor, QuizScoringModel de de map değiştirilmeli
        for (final result in state.results) {
          log(result.title);
          log(result.id);
          log((!scoring.resultPoints.containsKey(result.id)).toString());
          if (!scoring.resultPoints.containsKey(result.id)) {
            errors['scoring_incomplete'] =
                'Tüm seçenekler için puanlama tamamlanmalıdır';
            return ValidationResult.error(errors);
          }
        }
      }
    }

    // En az bir sonuç için pozitif puan var mı kontrolü
    bool hasAnyPositivePoints = false;
    for (final scoring in state.scoring) {
      if (scoring.resultPoints.values.any((point) => point > 0)) {
        hasAnyPositivePoints = true;
        break;
      }
    }

    if (!hasAnyPositivePoints) {
      errors['scoring_no_points'] =
          'En az bir seçenek için pozitif puan vermelisiniz';
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.error(errors);
  }

  /// Step 5: Önizlemeyi validate eder
  static ValidationResult validatePreview(CreateQuizState state) {
    // Önizleme step'inde tüm önceki step'leri kontrol et
    final step1Result = validateBasicInfo(state);
    if (!step1Result.isValid) {
      return ValidationResult.error({
        'preview': 'Temel bilgilerde eksiklikler var. Lütfen düzeltin.',
      });
    }

    final step2Result = validateQuestions(state);
    if (!step2Result.isValid) {
      return ValidationResult.error({
        'preview': 'Sorularda eksiklikler var. Lütfen düzeltin.',
      });
    }

    final step3Result = validateResults(state);
    if (!step3Result.isValid) {
      return ValidationResult.error({
        'preview': 'Sonuçlarda eksiklikler var. Lütfen düzeltin.',
      });
    }

    final step4Result = validateScoring(state);
    if (!step4Result.isValid) {
      return ValidationResult.error({
        'preview': 'Puanlama sisteminde eksiklikler var. Lütfen düzeltin.',
      });
    }

    return ValidationResult.success();
  }
}
