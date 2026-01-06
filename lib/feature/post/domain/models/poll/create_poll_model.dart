import 'package:prone/feature/post/domain/models/post_model.dart';

class CreatePollModel {
  final String? userId; // Optional user ID for the creator
  final String title;
  final String? body;
  final PostType type;
  final PostStatus status;
  final List<CreateOptionModel> options;

  // Poll-specific settings (from database design)
  final bool allowMultipleAnswers;
  final bool allowAddingOptions;
  final bool showResultsBeforeVoting;
  final DateTime? expiresAt;

  const CreatePollModel({
    this.userId,
    required this.title,
    this.body,
    required this.type,
    required this.options,
    this.status = PostStatus.published,
    this.allowMultipleAnswers = false,
    this.allowAddingOptions = false,
    this.showResultsBeforeVoting = false,
    this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId, // Optional user ID for the creator
      'title': title,
      'body': body, // Database field name is 'body'
      'post_type': type.name,
      'status': status.name,
      'allow_multiple_answers': allowMultipleAnswers,
      'allow_adding_options': allowAddingOptions,
      'show_results_before_voting': showResultsBeforeVoting,
      'expires_at': expiresAt?.toIso8601String(),
      'options': options.map((option) => option.text).toList(),
    };
  }

  // Method for creating posts table entry
  Map<String, dynamic> toPostJson() {
    return {
      'user_id': userId, // Optional user ID for the creator
      'title': title,
      'body': body,
      'post_type': type.name,
      'status': status.name,
      'allow_multiple_answers': allowMultipleAnswers,
      'allow_adding_options': allowAddingOptions,
      'show_results_before_voting': showResultsBeforeVoting,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  // Method for creating poll_options entries
  List<Map<String, dynamic>> toPollOptionsJson(String postId, String userId) {
    return options
        .map(
          (option) => {
            'post_id': postId,
            'option_text': option.text,
            'created_by_user_id': userId,
          },
        )
        .toList();
  }

  //CopyWith
  CreatePollModel copyWith({
    String? userId,
    String? title,
    String? body,
    PostType? type,
    PostStatus? status,
    List<CreateOptionModel>? options,
    bool? allowMultipleAnswers,
    bool? allowAddingOptions,
    bool? showResultsBeforeVoting,
    DateTime? expiresAt,
  }) {
    return CreatePollModel(
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      status: status ?? this.status,
      options: options ?? this.options,
      allowMultipleAnswers: allowMultipleAnswers ?? this.allowMultipleAnswers,
      allowAddingOptions: allowAddingOptions ?? this.allowAddingOptions,
      showResultsBeforeVoting:
          showResultsBeforeVoting ?? this.showResultsBeforeVoting,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class CreateOptionModel {
  final String? postId; // Optional post ID for the option
  final String text;
  final String? createdBy;

  const CreateOptionModel({this.createdBy, required this.text, this.postId});

  Map<String, dynamic> toJson() {
    return {
      'option_text': text,
      'created_by_user_id': createdBy,
      'post_id': postId,
    };
  }

  //CopyWith
  CreateOptionModel copyWith({
    String? text,
    String? createdBy,
    String? postId,
  }) {
    return CreateOptionModel(
      text: text ?? this.text,
      createdBy: createdBy ?? this.createdBy,
      postId: postId, // postId is not changed in copy
    );
  }
}
