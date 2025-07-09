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

  // ✅ toJson metodu
  Map<String, dynamic> toJson() {
    return {'id': id, 'questionText': questionText, 'options': options};
  }

  // ✅ fromJson metodu
  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      options: List<String>.from(json['options'] as List),
    );
  }
}
