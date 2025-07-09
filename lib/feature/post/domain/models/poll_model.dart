import 'package:prone/feature/post/domain/models/option_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';

class PollModel extends PostModel {
  final int totalVotes;
  final List<OptionModel> options;
  final bool userVoted;
  final String userVoteOption;

  const PollModel({
    super.id,
    required super.title,
    super.body,
    super.imageUrls,
    required super.userId,
    required super.createdAt,
    super.status,
    required this.totalVotes,
    required this.options,
    required this.userVoted,
    required this.userVoteOption,
  }) : super(type: PostType.poll);

  factory PollModel.fromJson(Map<String, dynamic> json) {
    return PollModel(
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
      totalVotes: json['total_votes'] as int? ?? 0,
      options: (json['options'] as List<dynamic>)
          .map((option) => OptionModel.fromJson(option as Map<String, dynamic>))
          .toList(),
      userVoted: json['user_voted'] as bool? ?? false,
      userVoteOption: json['user_vote_option'] as String? ?? '',
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
      'total_votes': totalVotes,
      'options': options.map((option) => option.toJson()).toList(),
      'user_voted': userVoted,
      'user_vote_option': userVoteOption,
    };
  }

  static PollModel mockData({
    String? id,
    String? title,
    String? body,
    List<String>? imageUrls,
    String? userId,
    DateTime? createdAt,
    PostStatus status = PostStatus.draft,
  }) {
    return PollModel(
      id: id ?? 'poll_${DateTime.now().millisecondsSinceEpoch}',
      title: title ?? 'Sample Poll',
      body: body ?? 'This is a sample poll description.',
      imageUrls:
          imageUrls ??
          ['https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo.png'],
      userId: userId ?? 'user_123',
      createdAt: createdAt ?? DateTime.now(),
      status: status,
      totalVotes: 5,
      options: [
        OptionModel(id: 'option_1', text: 'Option 1', votes: 3, percentage: 60),
        OptionModel(id: 'option_2', text: 'Option 2', votes: 2, percentage: 40),
      ],
      userVoted: true,
      userVoteOption: 'option_1',
    );
  }
}
