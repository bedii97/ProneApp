class QuizScoringModel {
  final String questionId;
  final String optionId;
  final Map<String, int> resultPoints; // resultId -> points

  const QuizScoringModel({
    required this.questionId,
    required this.optionId,
    required this.resultPoints,
  });

  QuizScoringModel copyWith({
    String? questionId,
    String? optionId,
    Map<String, int>? resultPoints,
  }) {
    return QuizScoringModel(
      questionId: questionId ?? this.questionId,
      optionId: optionId ?? this.optionId,
      resultPoints: resultPoints ?? this.resultPoints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'option_id': optionId,
      'result_mappings': resultPoints.entries
          .map((entry) => {'result_id': entry.key, 'points': entry.value})
          .toList(),
    };
  }

  factory QuizScoringModel.fromJson(Map<String, dynamic> json) {
    // Result points'i parse et
    final mappingsData = json['result_mappings'] as List<dynamic>? ?? [];
    final Map<String, int> resultPoints = {};

    for (final mapping in mappingsData) {
      final resultId = mapping['result_id'] as String;
      final points = mapping['points'] as int? ?? 0;
      resultPoints[resultId] = points;
    }

    return QuizScoringModel(
      questionId: json['question_id'] as String,
      optionId: json['option_id'] as String,
      resultPoints: resultPoints,
    );
  }

  // Database format - quiz_result_mappings tablosundan gelecek
  factory QuizScoringModel.fromDatabaseJson(Map<String, dynamic> json) {
    return QuizScoringModel(
      questionId: '', // Bu bilgi genelde parent'tan gelir
      optionId: json['option_id'] as String,
      resultPoints: {json['result_id'] as String: json['points'] as int? ?? 0},
    );
  }

  // Equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizScoringModel &&
        other.questionId == questionId &&
        other.optionId == optionId &&
        _mapEquals(other.resultPoints, resultPoints);
  }

  @override
  int get hashCode {
    return questionId.hashCode ^ optionId.hashCode ^ resultPoints.hashCode;
  }

  @override
  String toString() {
    return 'QuizScoringModel(questionId: $questionId, optionId: $optionId, resultPoints: $resultPoints)';
  }

  // Helper: Get points for specific result
  int getPointsForResult(String resultId) {
    return resultPoints[resultId] ?? 0;
  }

  // Helper: Check if has points for result
  bool hasPointsForResult(String resultId) {
    return resultPoints.containsKey(resultId) && resultPoints[resultId]! > 0;
  }

  // Helper: Get all result IDs
  List<String> get resultIds => resultPoints.keys.toList();

  // Helper: Get total points across all results
  int get totalPoints =>
      resultPoints.values.fold(0, (sum, points) => sum + points);

  // Helper: Get max points for any single result
  int get maxPoints => resultPoints.values.isEmpty
      ? 0
      : resultPoints.values.reduce((a, b) => a > b ? a : b);

  // Helper: Get result ID with highest points
  String? get topResultId {
    if (resultPoints.isEmpty) return null;

    String topId = resultPoints.keys.first;
    int maxPoints = resultPoints[topId]!;

    for (final entry in resultPoints.entries) {
      if (entry.value > maxPoints) {
        topId = entry.key;
        maxPoints = entry.value;
      }
    }

    return topId;
  }

  // Helper function for map equality
  bool _mapEquals(Map<String, int> map1, Map<String, int> map2) {
    if (map1.length != map2.length) return false;
    for (final entry in map1.entries) {
      if (map2[entry.key] != entry.value) return false;
    }
    return true;
  }

  // Static helper: Calculate total score for user answers
  static Map<String, int> calculateTotalScore(List<QuizScoringModel> scorings) {
    final Map<String, int> totalScores = {};

    for (final scoring in scorings) {
      for (final entry in scoring.resultPoints.entries) {
        totalScores[entry.key] = (totalScores[entry.key] ?? 0) + entry.value;
      }
    }

    return totalScores;
  }

  // Static helper: Determine winning result from scores
  static String? determineWinningResult(Map<String, int> scores) {
    if (scores.isEmpty) return null;

    String winningResult = scores.keys.first;
    int maxScore = scores[winningResult]!;

    for (final entry in scores.entries) {
      if (entry.value > maxScore) {
        winningResult = entry.key;
        maxScore = entry.value;
      }
    }

    return winningResult;
  }
}
