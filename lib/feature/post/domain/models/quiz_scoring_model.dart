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
      resultPoints: resultPoints ?? Map.from(this.resultPoints),
    );
  }

  // Helper: Get points for specific result
  int getPointsForResult(String resultId) {
    return resultPoints[resultId] ?? 0;
  }

  // Helper: Set points for specific result
  QuizScoringModel setPointsForResult(String resultId, int points) {
    final updatedPoints = Map<String, int>.from(resultPoints);
    updatedPoints[resultId] = points;
    return copyWith(resultPoints: updatedPoints);
  }

  // ✅ toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'optionId': optionId,
      'resultPoints': resultPoints,
    };
  }

  // ✅ fromJson metodu
  factory QuizScoringModel.fromJson(Map<String, dynamic> json) {
    return QuizScoringModel(
      questionId: json['questionId'] as String,
      optionId: json['optionId'] as String,
      resultPoints: Map<String, int>.from(json['resultPoints'] as Map),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizScoringModel &&
        other.questionId == questionId &&
        other.optionId == optionId;
  }

  @override
  int get hashCode {
    return questionId.hashCode ^ optionId.hashCode;
  }

  static QuizScoringModel mockData() {
    return QuizScoringModel(
      questionId: "1",
      optionId: "1",
      resultPoints: {"1": 10, "2": 5},
    );
  }
}
