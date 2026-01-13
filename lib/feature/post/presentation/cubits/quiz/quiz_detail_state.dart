import 'package:equatable/equatable.dart'; // State yönetimi için önerilir
import 'package:prone/feature/post/domain/models/quiz/quiz_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_question_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_result_model.dart';

enum QuizStatus { initial, loading, loaded, submitting, completed, error }

class QuizState extends Equatable {
  final QuizStatus status;
  final QuizModel? quiz; // Gerçek Quiz verisi
  final int currentIndex;

  // Cevaplar: Key -> QuestionID, Value -> OptionID
  final Map<String, String> answers;

  // Quiz bitince dönecek sonuç
  final QuizResultModel? result;
  final String? errorMessage;

  const QuizState({
    this.status = QuizStatus.initial,
    this.quiz,
    this.currentIndex = 0,
    this.answers = const {},
    this.result,
    this.errorMessage,
  });

  // Helper getters
  QuizQuestionModel? get currentQuestion =>
      (quiz != null && quiz!.questions.length > currentIndex)
      ? quiz!.questions[currentIndex]
      : null;

  bool get isLastQuestion =>
      quiz != null && currentIndex == quiz!.questions.length - 1;

  // Şu anki sorunun cevabı verilmiş mi?
  bool get isCurrentQuestionAnswered {
    final questionId = currentQuestion?.id;
    return questionId != null && answers.containsKey(questionId);
  }

  QuizState copyWith({
    QuizStatus? status,
    QuizModel? quiz,
    int? currentIndex,
    Map<String, String>? answers,
    QuizResultModel? result,
    String? errorMessage,
  }) {
    return QuizState(
      status: status ?? this.status,
      quiz: quiz ?? this.quiz,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    quiz,
    currentIndex,
    answers,
    result,
    errorMessage,
  ];
}
