import 'package:prone/feature/post/domain/models/create_quiz_model.dart';
import '../create_quiz_state.dart';

class CreateQuizModelBuilder {
  /// Ana method - CreateQuizState'ten CreateQuizModel oluşturur
  static CreateQuizModel build(CreateQuizState state) {
    return CreateQuizModel(
      title: state.title.trim(),
      body: state.description.trim().isEmpty ? null : state.description.trim(),
      questions: _buildQuestions(state),
      results: _buildResults(state),
      allowMultipleAnswers: false,
      allowAddingOptions: false,
      showResultsBeforeVoting: false,
      expiresAt: state.hasTimeLimit ? state.expiresAt : null,
    );
  }

  /// Questions'ları CreateQuizModel formatına dönüştürür
  static List<QuizQuestionInput> _buildQuestions(CreateQuizState state) {
    final questions = <QuizQuestionInput>[];

    for (
      int questionIndex = 0;
      questionIndex < state.questions.length;
      questionIndex++
    ) {
      final question = state.questions[questionIndex];

      // Boş soruları atla
      if (question.questionText.trim().isEmpty) continue;

      final options = <QuizOptionInput>[];

      // Her seçenek için
      for (
        int optionIndex = 0;
        optionIndex < question.options.length;
        optionIndex++
      ) {
        final optionText = question.options[optionIndex];

        // Boş seçenekleri atla
        if (optionText.trim().isEmpty) continue;

        final optionId = 'option_${questionIndex}_$optionIndex';
        final resultPoints = _buildResultPoints(state, question.id, optionId);

        options.add(
          QuizOptionInput(text: optionText.trim(), points: resultPoints),
        );
      }

      // En az 2 seçeneği olan soruları ekle
      if (options.length >= 2) {
        questions.add(
          QuizQuestionInput(
            text: question.questionText.trim(),
            options: options,
          ),
        );
      }
    }

    return questions;
  }

  /// Results'ları CreateQuizModel formatına dönüştürür
  static List<QuizResultInput> _buildResults(CreateQuizState state) {
    return state.results
        .where((result) => result.title.trim().isNotEmpty)
        .map(
          (result) => QuizResultInput(
            title: result.title.trim(),
            description: result.description.trim(),
          ),
        )
        .toList();
  }

  /// Belirli bir seçenek için result points'leri oluşturur
  static Map<String, int> _buildResultPoints(
    CreateQuizState state,
    String questionId,
    String optionId,
  ) {
    final points = <String, int>{};

    // İlgili scoring'i bul
    final scoring = state.scoring.firstWhere(
      (s) => s.questionId == questionId && s.optionId == optionId,
      orElse: () => throw StateError(
        'Scoring not found for question: $questionId, option: $optionId',
      ),
    );

    // Result ID'lerini title'lara dönüştür
    for (final result in state.results) {
      if (result.title.trim().isNotEmpty) {
        final pointValue = scoring.resultPoints[result.id] ?? 0;
        points[result.title.trim()] = pointValue;
      }
    }

    return points;
  }

  /// Debug amaçlı - model'in yapısını kontrol etmek için
  static void debugPrintModel(CreateQuizModel model) {
    print('=== CreateQuizModel Debug ===');
    print('Title: ${model.title}');
    print('Body: ${model.body}');
    print('Questions: ${model.questions.length}');

    for (int i = 0; i < model.questions.length; i++) {
      final question = model.questions[i];
      print('  Question ${i + 1}: ${question.text}');
      print('  Options: ${question.options.length}');

      for (int j = 0; j < question.options.length; j++) {
        final option = question.options[j];
        print('    Option ${j + 1}: ${option.text}');
        print('    Points: ${option.points}');
      }
    }

    print('Results: ${model.results.length}');
    for (int i = 0; i < model.results.length; i++) {
      final result = model.results[i];
      print('  Result ${i + 1}: ${result.title} - ${result.description}');
    }

    print('Expires At: ${model.expiresAt}');
    print('=== End Debug ===');
  }
}
