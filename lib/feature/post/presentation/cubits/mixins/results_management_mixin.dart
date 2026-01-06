import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_result_model.dart';
import '../create_quiz_state.dart';

mixin ResultsManagementMixin on Cubit<CreateQuizState> {
  /// Unique ID generator for results
  String _generateResultId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random =
        (timestamp * 991) % 1000000; // Different multiplier from questions
    return 'result_${timestamp}_$random';
  }

  /// Yeni sonuç ekler
  void addResult(QuizResultModel result) {
    final updatedResults = [...state.results, result];
    emit(state.copyWith(results: updatedResults));
  }

  /// Template'ten sonuç ekler
  void addResultFromTemplate(Map<String, dynamic> template) {
    final result = QuizResultModel(
      id: _generateResultId(),
      title: template['title'] ?? '',
      description: template['description'] ?? '',
      icon: template['icon'] ?? 'emoji_events',
      colorValue: template['colorValue'] ?? '#4CAF50',
    );
    addResult(result);
  }

  /// Boş sonuç ekler
  void addEmptyResult() {
    final result = QuizResultModel(
      id: _generateResultId(),
      title: '',
      description: '',
      icon: 'emoji_events',
      colorValue: '#4CAF50',
    );
    addResult(result);
  }

  /// Sonucu günceller
  void updateResult(int index, QuizResultModel updatedResult) {
    if (index < 0 || index >= state.results.length) {
      return; // Geçersiz index
    }

    final updatedResults = List<QuizResultModel>.from(state.results);
    updatedResults[index] = updatedResult;

    emit(state.copyWith(results: updatedResults));
  }

  /// Sonuç başlığını günceller
  void updateResultTitle(int index, String title) {
    if (index < 0 || index >= state.results.length) {
      return; // Geçersiz index
    }

    final currentResult = state.results[index];
    final updatedResult = currentResult.copyWith(title: title);
    updateResult(index, updatedResult);
  }

  /// Sonuç açıklamasını günceller
  void updateResultDescription(int index, String description) {
    if (index < 0 || index >= state.results.length) {
      return; // Geçersiz index
    }

    final currentResult = state.results[index];
    final updatedResult = currentResult.copyWith(description: description);
    updateResult(index, updatedResult);
  }

  /// Sonuç ikonunu günceller
  void updateResultIcon(int index, String icon) {
    if (index < 0 || index >= state.results.length) {
      return; // Geçersiz index
    }

    final currentResult = state.results[index];
    final updatedResult = currentResult.copyWith(icon: icon);
    updateResult(index, updatedResult);
  }

  /// Sonuç rengini günceller
  void updateResultColor(int index, String colorValue) {
    if (index < 0 || index >= state.results.length) {
      return; // Geçersiz index
    }

    final currentResult = state.results[index];
    final updatedResult = currentResult.copyWith(colorValue: colorValue);
    updateResult(index, updatedResult);
  }

  /// Sonucu siler (minimum 2 sonuç kalmalı)
  void removeResult(int index) {
    if (state.results.length <= 2) {
      return; // En az 2 sonuç olmalı
    }

    if (index < 0 || index >= state.results.length) {
      return; // Geçersiz index
    }

    final resultToRemove = state.results[index];
    final updatedResults = List<QuizResultModel>.from(state.results)
      ..removeAt(index);

    // Bu sonuca ait scoring'leri temizle
    final updatedScoring = state.scoring.map((scoring) {
      final updatedResultPoints = Map<String, int>.from(scoring.resultPoints);
      updatedResultPoints.remove(resultToRemove.id);

      return scoring.copyWith(resultPoints: updatedResultPoints);
    }).toList();

    emit(state.copyWith(results: updatedResults, scoring: updatedScoring));
  }

  /// Sonucu kopyalar
  void duplicateResult(int index) {
    if (index < 0 || index >= state.results.length) {
      return; // Geçersiz index
    }

    final originalResult = state.results[index];
    final duplicatedResult = QuizResultModel(
      id: _generateResultId(),
      title: '${originalResult.title} (Kopya)',
      description: originalResult.description,
      icon: originalResult.icon,
      colorValue: originalResult.colorValue,
    );

    final updatedResults = List<QuizResultModel>.from(state.results);
    updatedResults.insert(index + 1, duplicatedResult);

    emit(state.copyWith(results: updatedResults));
  }

  /// Sonuç sırasını değiştirir (drag & drop için)
  void reorderResults(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= state.results.length ||
        newIndex < 0 ||
        newIndex >= state.results.length) {
      return; // Geçersiz index'ler
    }

    if (oldIndex == newIndex) {
      return; // Aynı pozisyon
    }

    final updatedResults = List<QuizResultModel>.from(state.results);
    final result = updatedResults.removeAt(oldIndex);
    updatedResults.insert(newIndex, result);

    emit(state.copyWith(results: updatedResults));
  }

  /// Tüm sonuçları temizler ve 2 boş sonuç bırakır
  void resetAllResults() {
    final defaultResults = [
      QuizResultModel(
        id: _generateResultId(),
        title: '',
        description: '',
        icon: 'emoji_events',
        colorValue: '#4CAF50',
      ),
      QuizResultModel(
        id: _generateResultId(),
        title: '',
        description: '',
        icon: 'sentiment_satisfied',
        colorValue: '#2196F3',
      ),
    ];

    emit(
      state.copyWith(
        results: defaultResults,
        scoring: [], // Scoring'leri de temizle
      ),
    );
  }

  /// Popular result templates
  List<Map<String, dynamic>> getResultTemplates() {
    return [
      {
        'title': 'Mükemmel!',
        'description': 'Harika bir performans sergiledi!',
        'icon': 'emoji_events',
        'colorValue': '#FFD700',
        'category': 'success',
      },
      {
        'title': 'Çok İyi',
        'description': 'Gerçekten başarılı bir sonuç!',
        'icon': 'sentiment_very_satisfied',
        'colorValue': '#4CAF50',
        'category': 'success',
      },
      {
        'title': 'İyi',
        'description': 'Güzel bir performans!',
        'icon': 'sentiment_satisfied',
        'colorValue': '#2196F3',
        'category': 'good',
      },
      {
        'title': 'Orta',
        'description': 'Fena değil, daha iyisi olabilir.',
        'icon': 'sentiment_neutral',
        'colorValue': '#FF9800',
        'category': 'average',
      },
      {
        'title': 'Geliştirilmeli',
        'description': 'Biraz daha çalışmak gerekiyor.',
        'icon': 'sentiment_dissatisfied',
        'colorValue': '#F44336',
        'category': 'poor',
      },
    ];
  }

  /// Template kategorisine göre sonuçları filtreler
  List<Map<String, dynamic>> getResultTemplatesByCategory(String category) {
    return getResultTemplates()
        .where((template) => template['category'] == category)
        .toList();
  }

  /// Sonuç sayısını döndürür
  int get resultCount => state.results.length;

  /// Boş olmayan sonuçların sayısını döndürür
  int get validResultCount {
    return state.results
        .where((result) => result.title.trim().isNotEmpty)
        .length;
  }

  /// Belirli bir başlığa sahip sonucun index'ini bulur
  int findResultIndexByTitle(String title) {
    return state.results.indexWhere(
      (result) =>
          result.title.trim().toLowerCase() == title.trim().toLowerCase(),
    );
  }

  /// Belirli bir ID'ye sahip sonucun index'ini bulur
  int findResultIndexById(String id) {
    return state.results.indexWhere((result) => result.id == id);
  }

  /// Sonuç başlıklarının benzersiz olup olmadığını kontrol eder
  bool hasUniqueResultTitles() {
    final titles = state.results
        .map((r) => r.title.trim().toLowerCase())
        .where((title) => title.isNotEmpty)
        .toList();

    final uniqueTitles = titles.toSet();
    return uniqueTitles.length == titles.length;
  }

  /// Belirli bir sonucun tüm scoring'lerdeki toplam puanını hesaplar
  int getTotalPointsForResult(String resultId) {
    int totalPoints = 0;

    for (final scoring in state.scoring) {
      totalPoints += scoring.resultPoints[resultId] ?? 0;
    }

    return totalPoints;
  }
}
