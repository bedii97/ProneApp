import 'package:prone/feature/post/domain/models/poll/poll_model.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_model.dart';

enum PostType { poll, quiz }

enum PostStatus { draft, published, archived, deleted }

abstract class PostModel {
  final String? id;
  final String userId;
  final String title;
  final String? body;
  final List<String>? imageUrls;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final PostType type;
  final PostStatus status;

  // Posts tablosundaki poll/quiz ayarları
  final bool allowMultipleAnswers;
  final bool allowAddingOptions;
  final bool showResultsBeforeVoting;
  final DateTime? expiresAt;

  // Author bilgisi (join'den geliyor)
  final String authorUsername;
  final String? authorAvatarUrl;

  const PostModel({
    this.id,
    required this.userId,
    required this.title,
    this.body,
    this.imageUrls,
    required this.createdAt,
    this.updatedAt,
    required this.type,
    this.status = PostStatus.draft,
    required this.allowMultipleAnswers,
    required this.allowAddingOptions,
    required this.showResultsBeforeVoting,
    this.expiresAt,
    required this.authorUsername,
    this.authorAvatarUrl,
  });

  // Factory constructor - tip'a göre doğru model'i döndür
  factory PostModel.fromJson(Map<String, dynamic> json) {
    final type = PostType.values.firstWhere(
      (e) => e.name == (json['post_type'] as String? ?? 'poll'),
      orElse: () => PostType.poll,
    );

    switch (type) {
      case PostType.poll:
        return PollModel.fromJson(json);
      case PostType.quiz:
        return QuizModel.fromJson(json);
    }
  }

  // Common methods
  Map<String, dynamic> toBaseJson();

  // Utility getters
  bool get isDraft => status == PostStatus.draft;
  bool get isPublished => status == PostStatus.published;
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  // Type-safe casting helpers
  PollModel get asPoll => this as PollModel;
  QuizModel get asQuiz => this as QuizModel;
}
