import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_scoring_model.dart';
import '../cubits/quiz/create_quiz_state.dart';

mixin ScoringManagementMixin on Cubit<CreateQuizState> {
  /// Belirli bir seçenek için puanlamayı günceller
  void updateScoring(
    String questionId,
    String optionId,
    String resultId,
    int points,
  ) {
    final updatedScoring = List<QuizScoringModel>.from(state.scoring);

    // Mevcut scoring'i bul
    final existingIndex = updatedScoring.indexWhere(
      (s) => s.questionId == questionId && s.optionId == optionId,
    );

    if (existingIndex != -1) {
      // Mevcut scoring'i güncelle
      final existing = updatedScoring[existingIndex];
      final updatedResultPoints = Map<String, int>.from(existing.resultPoints);
      updatedResultPoints[resultId] = points;

      updatedScoring[existingIndex] = QuizScoringModel(
        questionId: existing.questionId,
        optionId: existing.optionId,
        resultPoints: updatedResultPoints,
      );
    } else {
      // Yeni scoring oluştur
      updatedScoring.add(
        QuizScoringModel(
          questionId: questionId,
          optionId: optionId,
          resultPoints: {resultId: points},
        ),
      );
    }

    emit(state.copyWith(scoring: updatedScoring));
  }

  /// Otomatik puanlama doldurma (her seçeneğe rastgele puanlar atar)
  void autoFillScoring() {
    final updatedScoring = <QuizScoringModel>[];

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
        final resultPoints = <String, int>{};

        // Her result için rastgele puan ata (1-5 arası)
        for (final result in state.results) {
          final randomPoints =
              (questionIndex + optionIndex + state.results.indexOf(result)) %
                  5 +
              1;
          resultPoints[result.id] = randomPoints;
        }

        updatedScoring.add(
          QuizScoringModel(
            questionId: question.id,
            optionId: optionId,
            resultPoints: resultPoints,
          ),
        );
      }
    }

    emit(state.copyWith(scoring: updatedScoring));
  }

  /// Balanced puanlama (her sonuca eşit şans verecek şekilde puanlar)
  void autoFillBalancedScoring() {
    final updatedScoring = <QuizScoringModel>[];
    final resultCount = state.results.length;

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
        final resultPoints = <String, int>{};

        // Her option farklı bir result'a daha yüksek puan versin
        for (
          int resultIndex = 0;
          resultIndex < state.results.length;
          resultIndex++
        ) {
          final result = state.results[resultIndex];

          // Bu seçeneğin hangi sonuca daha çok puan vereceğini belirle
          final targetResultIndex = (optionIndex) % resultCount;

          if (resultIndex == targetResultIndex) {
            resultPoints[result.id] = 3; // Hedef sonuca yüksek puan
          } else {
            resultPoints[result.id] = 1; // Diğer sonuçlara düşük puan
          }
        }

        updatedScoring.add(
          QuizScoringModel(
            questionId: question.id,
            optionId: optionId,
            resultPoints: resultPoints,
          ),
        );
      }
    }

    emit(state.copyWith(scoring: updatedScoring));
  }

  /// Tüm puanlamaları temizler
  void clearAllScoring() {
    emit(state.copyWith(scoring: []));
  }

  /// Belirli bir soruya ait puanlamaları temizler
  void clearQuestionScoring(String questionId) {
    final updatedScoring = state.scoring
        .where((s) => s.questionId != questionId)
        .toList();

    emit(state.copyWith(scoring: updatedScoring));
  }

  /// Belirli bir sonuca ait puanlamaları temizler
  void clearResultScoring(String resultId) {
    final updatedScoring = state.scoring.map((scoring) {
      final updatedResultPoints = Map<String, int>.from(scoring.resultPoints);
      updatedResultPoints.remove(resultId);

      return scoring.copyWith(resultPoints: updatedResultPoints);
    }).toList();

    emit(state.copyWith(scoring: updatedScoring));
  }

  /// Belirli bir seçeneğe ait puanlamaları temizler
  void clearOptionScoring(String questionId, String optionId) {
    final updatedScoring = state.scoring
        .where((s) => !(s.questionId == questionId && s.optionId == optionId))
        .toList();

    emit(state.copyWith(scoring: updatedScoring));
  }

  /// Belirli bir seçenek için puanlamayı getirir
  QuizScoringModel? getScoringForOption(String questionId, String optionId) {
    final matches = state.scoring.where(
      (s) => s.questionId == questionId && s.optionId == optionId,
    );

    return matches.isNotEmpty ? matches.first : null;
  }

  /// Belirli bir seçenek ve sonuç için puanı getirir
  int getPointsForOptionResult(
    String questionId,
    String optionId,
    String resultId,
  ) {
    final scoring = getScoringForOption(questionId, optionId);
    return scoring?.resultPoints[resultId] ?? 0;
  }

  /// Tüm seçeneklerin puanlandırıldığını kontrol eder
  bool isAllScoringComplete() {
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
        final scoring = getScoringForOption(question.id, optionId);

        if (scoring == null) return false;

        // Her result için puan var mı kontrol et
        for (final result in state.results) {
          if (!scoring.resultPoints.containsKey(result.id)) {
            return false;
          }
        }
      }
    }

    return true;
  }

  /// Eksik puanlamaları listeler
  List<Map<String, dynamic>> getMissingScoringItems() {
    final missing = <Map<String, dynamic>>[];

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
        final scoring = getScoringForOption(question.id, optionId);

        if (scoring == null) {
          missing.add({
            'questionIndex': questionIndex,
            'optionIndex': optionIndex,
            'questionText': question.questionText,
            'optionText': optionText,
            'missingResults': state.results.map((r) => r.title).toList(),
          });
        } else {
          final missingResults = <String>[];
          for (final result in state.results) {
            if (!scoring.resultPoints.containsKey(result.id)) {
              missingResults.add(result.title);
            }
          }

          if (missingResults.isNotEmpty) {
            missing.add({
              'questionIndex': questionIndex,
              'optionIndex': optionIndex,
              'questionText': question.questionText,
              'optionText': optionText,
              'missingResults': missingResults,
            });
          }
        }
      }
    }

    return missing;
  }

  /// Belirli bir sonucun toplam puanını hesaplar
  int getTotalPointsForResult(String resultId) {
    int totalPoints = 0;

    for (final scoring in state.scoring) {
      totalPoints += scoring.resultPoints[resultId] ?? 0;
    }

    return totalPoints;
  }

  /// En yüksek puana sahip sonucu bulur
  String? getHighestScoringResult() {
    if (state.results.isEmpty) return null;

    String? highestResult;
    int highestPoints = -1;

    for (final result in state.results) {
      final points = getTotalPointsForResult(result.id);
      if (points > highestPoints) {
        highestPoints = points;
        highestResult = result.id;
      }
    }

    return highestResult;
  }

  /// Puanlama istatistiklerini getirir
  Map<String, dynamic> getScoringStatistics() {
    final stats = <String, dynamic>{};

    // Toplam scoring sayısı
    stats['totalScoringItems'] = state.scoring.length;

    // Her result için toplam puanlar
    final resultPoints = <String, int>{};
    for (final result in state.results) {
      resultPoints[result.title] = getTotalPointsForResult(result.id);
    }
    stats['resultPoints'] = resultPoints;

    // Ortalama puanlar
    if (state.scoring.isNotEmpty) {
      final allPoints = state.scoring
          .expand((s) => s.resultPoints.values)
          .toList();

      final averagePoint = allPoints.reduce((a, b) => a + b) / allPoints.length;
      stats['averagePoint'] = averagePoint.toDouble();
    }

    // En yüksek ve en düşük puanlar
    if (resultPoints.isNotEmpty) {
      final points = resultPoints.values.toList();
      stats['highestPoint'] = points.reduce((a, b) => a > b ? a : b);
      stats['lowestPoint'] = points.reduce((a, b) => a < b ? a : b);
    }

    return stats;
  }

  /// Puanlamanın tamamlanma yüzdesini hesaplar
  double getScoringCompletionPercentage() {
    int totalRequired = 0;
    int completed = 0;

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
        final optionText = question.options[optionIndex];
        if (optionText.text.trim().isEmpty) continue;

        totalRequired += state.results.length; // Her result için puan gerekli

        final optionId = 'option_${questionIndex}_$optionIndex';
        final scoring = getScoringForOption(question.id, optionId);

        if (scoring != null) {
          completed += scoring.resultPoints.length;
        }
      }
    }

    if (totalRequired == 0) return 0.0;
    return (completed / totalRequired) * 100;
  }
}
