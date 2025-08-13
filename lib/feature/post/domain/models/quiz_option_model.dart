class QuizOptionModel {
  final String id;
  final String text;
  final String questionId;

  // Quiz result mappings (option_id -> result_id -> points)
  final Map<String, int> resultMappings; // resultId -> points

  const QuizOptionModel({
    required this.id,
    required this.text,
    required this.questionId,
    this.resultMappings = const {},
  });

  // copyWith method
  QuizOptionModel copyWith({
    String? id,
    String? text,
    String? questionId,
    Map<String, int>? resultMappings,
  }) {
    return QuizOptionModel(
      id: id ?? this.id,
      text: text ?? this.text,
      questionId: questionId ?? this.questionId,
      resultMappings: resultMappings ?? this.resultMappings,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'option_text': text, // Database field name
      'question_id': questionId,
      'result_mappings': resultMappings.entries
          .map((entry) => {'result_id': entry.key, 'points': entry.value})
          .toList(),
    };
  }

  factory QuizOptionModel.fromJson(Map<String, dynamic> json) {
    // Result mappings'i parse et
    final mappingsData = json['quiz_result_mappings'] as List<dynamic>? ?? [];
    final Map<String, int> resultMappings = {};

    for (final mapping in mappingsData) {
      final resultData = mapping['quiz_results'] as Map<String, dynamic>?;
      final resultId = resultData?['id'] as String?;
      final points = mapping['points'] as int? ?? 0;

      if (resultId != null) {
        resultMappings[resultId] = points;
      }
    }

    return QuizOptionModel(
      id: json['id'] as String,
      text: json['option_text'] as String,
      questionId: json['question_id'] as String? ?? '', // Parent'tan gelecek
      resultMappings: resultMappings,
    );
  }

  // Equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizOptionModel &&
        other.id == id &&
        other.text == text &&
        other.questionId == questionId &&
        _mapEquals(other.resultMappings, resultMappings);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        questionId.hashCode ^
        resultMappings.hashCode;
  }

  @override
  String toString() {
    return 'QuizOptionModel(id: $id, text: $text, questionId: $questionId, resultMappings: $resultMappings)';
  }

  // Helper methods
  bool hasResultMapping(String resultId) {
    return resultMappings.containsKey(resultId);
  }

  int getPointsForResult(String resultId) {
    return resultMappings[resultId] ?? 0;
  }

  List<String> get mappedResultIds => resultMappings.keys.toList();

  bool get hasAnyMapping => resultMappings.isNotEmpty;

  // Helper function for map equality
  bool _mapEquals(Map<String, int> map1, Map<String, int> map2) {
    if (map1.length != map2.length) return false;
    for (final entry in map1.entries) {
      if (map2[entry.key] != entry.value) return false;
    }
    return true;
  }
}
