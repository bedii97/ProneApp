import 'package:prone/feature/post/domain/models/quiz/quiz_user_result_model.dart';

class QuizUserCompletionModel {
  final String id;
  final int totalPoints;
  final DateTime createdAt;
  final QuizUserResultModel quizResult;

  const QuizUserCompletionModel({
    required this.id,
    required this.totalPoints,
    required this.createdAt,
    required this.quizResult,
  });

  factory QuizUserCompletionModel.fromJson(Map<String, dynamic> json) {
    return QuizUserCompletionModel(
      id: json['id'] as String,
      totalPoints: json['total_points'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      quizResult: QuizUserResultModel.fromJson(
        json['quiz_results'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_points': totalPoints,
      'created_at': createdAt.toIso8601String(),
      'quiz_results': quizResult.toJson(),
    };
  }
}
