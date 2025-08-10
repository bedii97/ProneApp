class QuizQuestionModel {
  final String id;
  final String questionText;
  final List<String> options; // Option IDs

  const QuizQuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
  });

  QuizQuestionModel copyWith({
    String? id,
    String? questionText,
    List<String>? options,
  }) {
    return QuizQuestionModel(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'questionText': questionText, 'options': options};
  }

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    try {
      final optionsJson = json['quiz_options'] as List<dynamic>?;

      return QuizQuestionModel(
        id: json['id'] as String,
        questionText:
            json['question_text'] as String, // ✅ snake_case'e değiştirildi
        options: optionsJson != null
            ? optionsJson.map((option) {
                // quiz_options içindeki her option bir Map<String, dynamic>
                if (option is Map<String, dynamic>) {
                  return option['option_text']
                      as String; // ✅ option_text field'ını al
                }
                return option.toString();
              }).toList()
            : <String>[],
      );
    } catch (e) {
      rethrow;
    }
  }
}
