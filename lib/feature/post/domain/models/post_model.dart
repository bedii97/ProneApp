import 'package:prone/feature/post/domain/models/create_option_model.dart';

enum PostType { poll, quiz }

enum PostStatus { active, inactive, expired }

class OptionModel {
  final String id;
  final String text;
  final int votes;
  final double percentage;

  OptionModel({
    required this.id,
    required this.text,
    required this.votes,
    required this.percentage,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      votes: json['votes'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory OptionModel.fromCreateOptionModel({
    required CreateOptionModel option,
    required String optionId,
  }) {
    return OptionModel(
      id: optionId,
      text: option.text,
      votes: 0,
      percentage: 0.0,
    );
  }
}

class PollSettings {
  final bool allowMultipleVotes;

  PollSettings({required this.allowMultipleVotes});

  Map<String, dynamic> toJson() {
    return {'allow_multiple_votes': allowMultipleVotes};
  }

  factory PollSettings.fromJson(Map<String, dynamic> json) {
    return PollSettings(
      allowMultipleVotes: json['allow_multiple_votes'] as bool? ?? false,
    );
  }
}

class PostModel {
  final String? id;
  final String title;
  final String? description;
  final String userId;
  final DateTime createdAt;
  final int totalVotes;
  final List<OptionModel> options;
  final bool userVoted;
  final String userVoteOption;
  final PollSettings pollSettings;
  final PostType type;

  PostModel({
    this.id,
    required this.title,
    this.description,
    required this.userId,
    required this.createdAt,
    required this.totalVotes,
    required this.options,
    required this.userVoted,
    required this.userVoteOption,
    required this.pollSettings,
    this.type = PostType.poll,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: PostType.values.firstWhere(
        (e) => e.name == (json['type'] as String? ?? 'poll'),
        orElse: () => PostType.poll,
      ),
      title: json['title'] as String,
      description: json['description'] as String?,
      pollSettings: (json['poll_settings'] as Map<String, dynamic>?) != null
          ? PollSettings.fromJson(json['poll_settings'] as Map<String, dynamic>)
          : PollSettings(allowMultipleVotes: false),
      createdAt: DateTime.parse(json['created_at'] as String),
      totalVotes: json['total_votes'] as int? ?? 0,
      options: (json['options'] as List<dynamic>).map((option) {
        return OptionModel.fromJson(option as Map<String, dynamic>);
      }).toList(),
      userVoted: json['user_voted'] as bool? ?? false,
      userVoteOption: json['user_vote_option'] as String? ?? '',
    );
  }
}
