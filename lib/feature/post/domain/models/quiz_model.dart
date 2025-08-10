import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'package:prone/feature/post/domain/models/quiz_result_model.dart';
import 'package:prone/feature/post/domain/models/quiz_scoring_model.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_state.dart';

class QuizModel extends PostModel {
  final String? description;
  final List<QuizQuestionModel> questions;
  final List<QuizResultModel> results;
  final List<QuizScoringModel> scoring;
  final bool hasTimeLimit;
  final DateTime? expiresAt;
  final int totalParticipants;
  final bool userParticipated;
  final String? userResultId;

  const QuizModel({
    super.id,
    required super.title,
    super.body,
    super.imageUrls,
    required super.userId,
    required super.createdAt,
    super.status,
    this.description,
    required this.questions,
    required this.results,
    required this.scoring,
    this.hasTimeLimit = false,
    this.expiresAt,
    this.totalParticipants = 0,
    this.userParticipated = false,
    this.userResultId,
  }) : super(type: PostType.quiz);

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    try {
      final questionsJson = json['quiz_questions'] as List<dynamic>?;
      final resultsJson = json['quiz_results'] as List<dynamic>?;
      final scoringJson = json['scoring'] as List<dynamic>?; // ✅ Null olabilir

      return QuizModel(
        id: json['id'] as String?,
        title: json['title'] as String,
        body: json['body'] as String?,
        imageUrls: json['image_urls'] != null
            ? List<String>.from(json['image_urls'] as List)
            : null,
        userId: json['user_id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        status: PostStatus.values.firstWhere(
          (e) => e.name == (json['status'] as String? ?? 'draft'),
          orElse: () => PostStatus.draft,
        ),
        description: json['description'] as String?,
        questions: questionsJson != null
            ? questionsJson
                  .map(
                    (q) =>
                        QuizQuestionModel.fromJson(q as Map<String, dynamic>),
                  )
                  .toList()
            : <QuizQuestionModel>[],
        results: resultsJson != null
            ? resultsJson
                  .map(
                    (r) => QuizResultModel.fromJson(r as Map<String, dynamic>),
                  )
                  .toList()
            : <QuizResultModel>[],
        scoring:
            scoringJson !=
                null // ✅ Null check eklendi
            ? scoringJson
                  .map(
                    (s) => QuizScoringModel.fromJson(s as Map<String, dynamic>),
                  )
                  .toList()
            : <QuizScoringModel>[], // ✅ Boş liste
        hasTimeLimit: json['has_time_limit'] as bool? ?? false,
        expiresAt: json['expires_at'] != null
            ? DateTime.parse(json['expires_at'] as String)
            : null,
        totalParticipants: json['total_participants'] as int? ?? 0,
        userParticipated: json['user_participated'] as bool? ?? false,
        userResultId: json['user_result_id'] as String?,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Factory from CreateQuizState
  factory QuizModel.fromCreateQuizState(CreateQuizState state, String userId) {
    return QuizModel(
      title: state.title,
      body: state.description,
      userId: userId,
      createdAt: DateTime.now(),
      status: PostStatus.draft,
      description: state.description,
      questions: state.questions,
      results: state.results,
      scoring: state.scoring,
      hasTimeLimit: state.hasTimeLimit,
      expiresAt: state.expiresAt,
    );
  }

  @override
  Map<String, dynamic> toBaseJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'image_urls': imageUrls,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'post_type': type.name,
      'status': status.name,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
      'results': results.map((r) => r.toJson()).toList(),
      'scoring': scoring.map((s) => s.toJson()).toList(),
      'has_time_limit': hasTimeLimit,
      'expires_at': expiresAt?.toIso8601String(),
      'total_participants': totalParticipants,
      'user_participated': userParticipated,
      'user_result_id': userResultId,
    };
  }

  // Helper: Check if quiz is valid for publishing
  bool get isValidForPublishing {
    return title.isNotEmpty &&
        questions.length >= 2 &&
        results.length >= 2 &&
        scoring.isNotEmpty;
  }

  // Helper: Get user's quiz result
  QuizResultModel? get userResult {
    if (userResultId == null) return null;
    return results.where((r) => r.id == userResultId).firstOrNull;
  }

  QuizModel copyWith({
    String? id,
    String? title,
    String? body,
    List<String>? imageUrls,
    String? userId,
    DateTime? createdAt,
    PostStatus? status,
    String? description,
    List<QuizQuestionModel>? questions,
    List<QuizResultModel>? results,
    List<QuizScoringModel>? scoring,
    bool? hasTimeLimit,
    DateTime? expiresAt,
    int? totalParticipants,
    bool? userParticipated,
    String? userResultId,
  }) {
    return QuizModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrls: imageUrls ?? this.imageUrls,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      results: results ?? this.results,
      scoring: scoring ?? this.scoring,
      hasTimeLimit: hasTimeLimit ?? this.hasTimeLimit,
      expiresAt: expiresAt ?? this.expiresAt,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      userParticipated: userParticipated ?? this.userParticipated,
      userResultId: userResultId ?? this.userResultId,
    );
  }
}
