import 'package:prone/feature/post/domain/models/poll_model.dart';
import 'package:prone/feature/post/domain/models/quiz_model.dart';

enum PostType { poll, quiz }

enum PostStatus { draft, published, archived, deleted }

abstract class PostModel {
  final String? id;
  final String title;
  final String? body;
  final List<String>? imageUrls;
  final String userId;
  final DateTime createdAt;
  final PostType type;
  final PostStatus status;

  const PostModel({
    this.id,
    required this.title,
    this.body,
    this.imageUrls,
    required this.userId,
    required this.createdAt,
    required this.type,
    this.status = PostStatus.draft,
  });

  // Common methods
  Map<String, dynamic> toBaseJson();
  static PostModel fromJson(Map<String, dynamic> json) {
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
}
