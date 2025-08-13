import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'package:prone/feature/post/domain/models/quiz_result_model.dart';

class QuizModel extends PostModel {
  // Quiz-specific data (JSON'daki "quiz" object'inden gelecek)
  final List<QuizQuestionModel> questions;
  final List<QuizResultModel> results;

  // User interaction state
  final bool userCompleted;
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
    required this.userCompleted,
    this.userResultId,
    this.userTotalPoints,
    required this.completionCount,
  }) : super(type: PostType.quiz);

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    // Author bilgisi
    final usersData = json['users'] as Map<String, dynamic>? ?? {};

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

    // User completion durumu
    final completionsData = json['quiz_completions'] as List<dynamic>? ?? [];
    final userCompletion = completionsData.isNotEmpty
        ? completionsData.first
        : null;
    final userCompleted = userCompletion != null;
    final userResultId = userCompletion?['result_id'] as String?;
    final userTotalPoints = userCompletion?['total_points'] as int?;

    return QuizModel(
      // Base fields
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
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
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      authorUsername: usersData['username'] as String? ?? 'Unknown',
      authorAvatarUrl: usersData['avatar_url'] as String?,

      // Quiz-specific fields
      questions: questions,
      results: results,
      userCompleted: userCompleted,
      userResultId: userResultId,
      userTotalPoints: userTotalPoints,
      completionCount: 0, // TODO: Implement with count query
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
        'user_completed': userCompleted,
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
  int get questionCount => questions.length;
  int get resultCount => results.length;
  bool get hasExpired => isExpired;
  bool get canTakeQuiz => !userCompleted && !hasExpired;
  bool get canSeeResults =>
      showResultsBeforeVoting || userCompleted || hasExpired;

  // Calculate score for given answers
  Map<String, int> calculateScore(Map<String, String> userAnswers) {
    final Map<String, int> scores = {};

    // Initialize scores
    for (final result in results) {
      scores[result.id] = 0;
    }

    // Calculate points for each answer
    for (final entry in userAnswers.entries) {
      final questionId = entry.key;
      final optionId = entry.value;

      final question = getQuestionById(questionId);
      if (question != null) {
        final option = question.getOptionById(optionId);
        if (option != null) {
          for (final resultEntry in option.resultMappings.entries) {
            scores[resultEntry.key] =
                (scores[resultEntry.key] ?? 0) + resultEntry.value;
          }
        }
      }
    }

    return scores;
  }

  // Determine winning result from scores
  String? determineResult(Map<String, int> scores) {
    if (scores.isEmpty) return null;

    String? winningResultId;
    int maxScore = -1;

    for (final entry in scores.entries) {
      if (entry.value > maxScore) {
        winningResultId = entry.key;
        maxScore = entry.value;
      }
    }

    return winningResultId;
  }

  // Mock data for testing
  static QuizModel mockData({
    String? id,
    String? title,
    String? body,
    String? userId,
    DateTime? createdAt,
    PostStatus status = PostStatus.published,
  }) {
    return QuizModel(
      // PostModel fields
      id: id ?? 'quiz_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId ?? 'user_123',
      title: title ?? 'Personality Quiz',
      body: body ?? 'Discover your personality type!',
      createdAt: createdAt ?? DateTime.now(),
      status: status,
      allowMultipleAnswers: false,
      allowAddingOptions: false,
      showResultsBeforeVoting: false,
      authorUsername: 'test_user',

      // Quiz-specific fields
      questions: [],
      results: [],
      userCompleted: false,
      completionCount: 0,
    );
  }

  @override
  String toString() {
    return 'QuizModel(id: $id, title: $title, questions: ${questions.length}, results: ${results.length}, userCompleted: $userCompleted)';
  }
}
