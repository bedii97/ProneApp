import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_question_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_result_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_user_completion_model.dart';

class QuizModel extends PostModel {
  // Quiz-specific data (JSON'daki "quiz" object'inden gelecek)
  final List<QuizQuestionModel> questions;
  final List<QuizResultModel> results;
  final QuizUserCompletionModel? completion;

  // User interaction state
  final String? userResultId;
  final int? userTotalPoints;

  // Quiz statistics
  final int completionCount;

  const QuizModel({
    // PostModel fields
    super.id,
    required super.userId,
    required super.title,
    super.body,
    super.imageUrls,
    required super.createdAt,
    super.updatedAt,
    super.status = PostStatus.published,
    required super.allowMultipleAnswers,
    required super.allowAddingOptions,
    required super.showResultsBeforeVoting,
    super.expiresAt,
    required super.authorUsername,
    super.authorAvatarUrl,

    // Quiz-specific fields
    required this.questions,
    required this.results,
    required this.completion,
    this.userResultId,
    this.userTotalPoints,
    required this.completionCount,
  }) : super(type: PostType.quiz);

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    // User bilgisi
    final usersData = json['users'] as Map<String, dynamic>? ?? {}; //TMM

    // Questions'ları parse et
    final questionsData = json['quiz_questions'] as List<dynamic>? ?? [];
    final questions = questionsData.map((questionData) {
      return QuizQuestionModel.fromJson(questionData);
    }).toList();

    // Sort by order
    questions.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    // Results'ları parse et
    final resultsData = json['quiz_results'] as List<dynamic>? ?? [];
    final results = resultsData.map((resultData) {
      return QuizResultModel.fromJson(resultData);
    }).toList();

    QuizUserCompletionModel? completion;
    // User completion durumu
    if (json['user_completion'] != null) {
      final completionData =
          json['user_completion'] as Map<String, dynamic>? ?? {};
      completion = QuizUserCompletionModel.fromJson(completionData);
    }

    return QuizModel(
      // Base fields
      id: json['id'] as String?, //TMM
      userId:
          (json['user_id'] as String?) ??
          (usersData['id'] as String? ?? ''), //TMM
      title: json['title'] as String, //TMM
      body: json['body'] as String?, //TMM
      createdAt: DateTime.parse(json['created_at'] as String), //TMM
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      status: PostStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'published'),
        orElse: () => PostStatus.published,
      ),
      allowMultipleAnswers: json['allow_multiple_answers'] as bool? ?? false,
      allowAddingOptions: json['allow_adding_options'] as bool? ?? false,
      showResultsBeforeVoting:
          json['show_results_before_voting'] as bool? ?? false,
      expiresAt:
          json['expires_at'] !=
              null //TMM
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      authorUsername: usersData['username'] as String? ?? 'Unknown', //TMM
      authorAvatarUrl: usersData['avatar_url'] as String?, //TMM
      // Quiz-specific fields
      completion: completion,
      questions: questions,
      results: results,
      completionCount: 0, // Todo: Implement with count query
    );
  }

  @override
  Map<String, dynamic> toBaseJson() {
    return {
      // Base PostModel fields
      'id': id,
      'user_id': userId,
      'post_type': type.name,
      'title': title,
      'body': body,
      'allow_multiple_answers': allowMultipleAnswers,
      'allow_adding_options': allowAddingOptions,
      'show_results_before_voting': showResultsBeforeVoting,
      'expires_at': expiresAt?.toIso8601String(),
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'author': {'username': authorUsername, 'avatar_url': authorAvatarUrl},

      // Quiz-specific data (nested object)
      'quiz': {
        'questions': questions.map((question) => question.toJson()).toList(),
        'results': results.map((result) => result.toJson()).toList(),
        'user_result_id': userResultId,
        'user_total_points': userTotalPoints,
        'completion_count': completionCount,
      },
    };
  }

  // Quiz-specific helper methods
  QuizQuestionModel? getQuestionById(String questionId) {
    try {
      return questions.firstWhere((q) => q.id == questionId);
    } catch (e) {
      return null;
    }
  }

  QuizResultModel? getResultById(String resultId) {
    try {
      return results.firstWhere((r) => r.id == resultId);
    } catch (e) {
      return null;
    }
  }

  QuizResultModel? get userResult {
    if (userResultId == null) return null;
    return getResultById(userResultId!);
  }

  // Quiz state helpers
  bool get userCompleted => completion != null;
  int get questionCount => questions.length;
  int get resultCount => results.length;
  bool get hasExpired => isExpired;
  bool get canTakeQuiz => !userCompleted && !hasExpired;
  bool get canSeeResults => showResultsBeforeVoting || userCompleted;
  bool get hasResult => userResultId != null;

  @override
  String toString() {
    return 'QuizModel(id: $id, title: $title, questions: ${questions.length}, results: ${results.length}, userCompleted: $userCompleted)';
  }
}
