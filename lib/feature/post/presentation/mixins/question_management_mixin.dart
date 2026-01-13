import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_option_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_question_model.dart';
import '../cubits/quiz/create_quiz_state.dart';

mixin QuestionManagementMixin on Cubit<CreateQuizState> {
  /// Unique ID generator
  String _generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 997) % 1000000; // Simple hash
    return '${timestamp}_$random';
  }

  /// Yeni soru ekler
  void addQuestion() {
    final newQuestion = QuizQuestionModel(
      id: _generateUniqueId(),
      questionText: '',
      options: [], // Başlangıçta 2 boş seçenek
      orderIndex: 0,
    );

    final updatedQuestions = [...state.questions, newQuestion];
    emit(state.copyWith(questions: updatedQuestions));
  }

  /// Soru siler (minimum 1 soru kalmalı)
  void removeQuestion(int index) {
    if (state.questions.length <= 1) {
      return; // En az 1 soru olmalı
    }

    if (index < 0 || index >= state.questions.length) {
      return; // Geçersiz index
    }

    final updatedQuestions = List<QuizQuestionModel>.from(state.questions)
      ..removeAt(index);

    // Bu soruya ait scoring'leri de temizle
    final questionId = state.questions[index].id;
    final updatedScoring = state.scoring
        .where((s) => s.questionId != questionId)
        .toList();

    emit(state.copyWith(questions: updatedQuestions, scoring: updatedScoring));
  }

  /// Soru metnini günceller
  void updateQuestionText(int index, String text) {
    if (index < 0 || index >= state.questions.length) {
      return; // Geçersiz index
    }

    final updatedQuestions = List<QuizQuestionModel>.from(state.questions);
    updatedQuestions[index] = updatedQuestions[index].copyWith(
      questionText: text,
    );

    emit(state.copyWith(questions: updatedQuestions));
  }

  /// Soruya yeni seçenek ekler
  void addOption(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= state.questions.length) {
      return; // Geçersiz index
    }

    final question = state.questions[questionIndex];
    if (question.options.length >= 6) {
      return; // Maksimum 6 seçenek
    }

    final updatedQuestions = List<QuizQuestionModel>.from(state.questions);
    final updatedOptions = List<QuizOptionModel>.from(question.options)
      ..add(
        QuizOptionModel(
          id: _generateUniqueId(),
          text: '',
          questionId: question.id,
        ),
      );

    updatedQuestions[questionIndex] = question.copyWith(
      options: updatedOptions,
    );

    emit(state.copyWith(questions: updatedQuestions));
  }

  /// Seçenek siler (minimum 2 seçenek kalmalı)
  void removeOption(int questionIndex, int optionIndex) {
    if (questionIndex < 0 || questionIndex >= state.questions.length) {
      return; // Geçersiz question index
    }

    final question = state.questions[questionIndex];

    if (question.options.length <= 2) {
      return; // En az 2 seçenek olmalı
    }

    if (optionIndex < 0 || optionIndex >= question.options.length) {
      return; // Geçersiz option index
    }

    final updatedQuestions = List<QuizQuestionModel>.from(state.questions);
    final updatedOptions = List<QuizOptionModel>.from(question.options)
      ..removeAt(optionIndex);

    updatedQuestions[questionIndex] = question.copyWith(
      options: updatedOptions,
    );

    // Bu seçeneğe ait scoring'leri temizle
    final optionId = 'option_${questionIndex}_$optionIndex';
    final updatedScoring = state.scoring
        .where((s) => !(s.questionId == question.id && s.optionId == optionId))
        .toList();

    emit(state.copyWith(questions: updatedQuestions, scoring: updatedScoring));
  }

  /// Seçenek metnini günceller
  void updateOption(int questionIndex, int optionIndex, String value) {
    if (questionIndex < 0 || questionIndex >= state.questions.length) {
      return; // Geçersiz question index
    }

    final question = state.questions[questionIndex];

    if (optionIndex < 0 || optionIndex >= question.options.length) {
      return; // Geçersiz option index
    }

    final updatedQuestions = List<QuizQuestionModel>.from(state.questions);
    final updatedOptions = List<QuizOptionModel>.from(question.options);
    updatedOptions[optionIndex] = updatedOptions[optionIndex].copyWith(
      text: value,
    );

    updatedQuestions[questionIndex] = question.copyWith(
      options: updatedOptions,
    );

    emit(state.copyWith(questions: updatedQuestions));
  }

  /// Soru sırasını değiştirir (drag & drop için)
  void reorderQuestions(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= state.questions.length ||
        newIndex < 0 ||
        newIndex >= state.questions.length) {
      return; // Geçersiz index'ler
    }

    if (oldIndex == newIndex) {
      return; // Aynı pozisyon
    }

    final updatedQuestions = List<QuizQuestionModel>.from(state.questions);
    final question = updatedQuestions.removeAt(oldIndex);
    updatedQuestions.insert(newIndex, question);

    emit(state.copyWith(questions: updatedQuestions));
  }

  /// Soruyu kopyalar
  void duplicateQuestion(int index) {
    if (index < 0 || index >= state.questions.length) {
      return; // Geçersiz index
    }

    final originalQuestion = state.questions[index];
    final duplicatedQuestion = QuizQuestionModel(
      id: _generateUniqueId(),
      orderIndex:
          originalQuestion.orderIndex + 1, // Yeni soru için sıra numarası
      questionText: '${originalQuestion.questionText} (Kopya)',
      options: List<QuizOptionModel>.from(originalQuestion.options),
    );

    final updatedQuestions = List<QuizQuestionModel>.from(state.questions);
    updatedQuestions.insert(index + 1, duplicatedQuestion);

    emit(state.copyWith(questions: updatedQuestions));
  }

  /// Tüm soruları temizler ve 1 boş soru bırakır
  void resetAllQuestions() {
    final defaultQuestion = QuizQuestionModel(
      id: _generateUniqueId(),
      orderIndex: 0,
      questionText: '',
      options: List<QuizOptionModel>.generate(2, (index) {
        return QuizOptionModel(
          id: _generateUniqueId(),
          text: '',
          questionId:
              _generateUniqueId(), // Yeni ID, çünkü bu seçenekler yeni bir soruya ait
        );
      }),
    );

    emit(
      state.copyWith(
        questions: [defaultQuestion],
        scoring: [], // Scoring'leri de temizle
      ),
    );
  }

  /// Soru sayısını döndürür
  int get questionCount => state.questions.length;

  /// Belirli bir sorunun seçenek sayısını döndürür
  int getOptionCount(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= state.questions.length) {
      return 0;
    }
    return state.questions[questionIndex].options.length;
  }

  /// Boş olmayan sorular sayısını döndürür
  int get validQuestionCount {
    return state.questions
        .where((q) => q.questionText.trim().isNotEmpty)
        .length;
  }

  /// Belirli bir sorunun boş olmayan seçeneklerinin sayısını döndürür
  int getValidOptionCount(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= state.questions.length) {
      return 0;
    }
    return state.questions[questionIndex].options
        .where((QuizOptionModel option) => option.text.trim().isNotEmpty)
        .length;
  }
}
