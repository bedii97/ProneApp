class QuizQuestion {
  String questionText;
  List<String> options;
  int? correctAnswerIndex;

  QuizQuestion({
    this.questionText = '',
    List<String>? options,
    this.correctAnswerIndex,
  }) : options = options ?? [''];

  QuizQuestion copyWith({
    String? questionText,
    List<String>? options,
    int? correctAnswerIndex,
  }) {
    return QuizQuestion(
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
    );
  }
}
