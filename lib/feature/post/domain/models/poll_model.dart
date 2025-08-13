import 'package:prone/feature/post/domain/models/option_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';

class PollModel extends PostModel {
  // Poll-specific data (JSON'daki "poll" object'inden gelecek)
  final List<OptionModel> options;
  final int totalVotes;

  // User interaction state
  final bool userVoted;
  final String? userVoteOptionId; // Değişti: userVoteOption -> userVoteOptionId

  const PollModel({
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

    // Poll-specific fields
    required this.options,
    required this.totalVotes,
    required this.userVoted,
    this.userVoteOptionId,
  }) : super(type: PostType.poll);

  factory PollModel.fromJson(Map<String, dynamic> json) {
    // Author bilgisi
    final usersData = json['users'] as Map<String, dynamic>? ?? {};

    // Poll options'ları işle
    final pollOptionsData = json['poll_options'] as List<dynamic>? ?? [];
    List<OptionModel> options = [];
    int totalVotes = 0;

    for (final optionData in pollOptionsData) {
      // Vote count'u hesapla
      final userVotesData = optionData['user_votes'] as List<dynamic>? ?? [];
      final voteCount = userVotesData.isNotEmpty
          ? (userVotesData.first['count'] as int? ?? 0)
          : 0;

      totalVotes += voteCount;

      options.add(
        OptionModel(
          id: optionData['id'] as String,
          text: optionData['option_text'] as String,
          votes: voteCount,
          percentage: 0.0, // Sonra hesaplanacak
        ),
      );
    }

    // Percentage'ları hesapla
    for (int i = 0; i < options.length; i++) {
      final percentage = totalVotes > 0
          ? (options[i].votes / totalVotes * 100)
          : 0.0;
      options[i] = options[i].copyWith(percentage: percentage);
    }

    // User'ın vote durumu
    final userVotesData = json['user_votes'] as List<dynamic>? ?? [];
    final userVoteOptionId = userVotesData.isNotEmpty
        ? userVotesData.first['option_id'] as String?
        : null;
    final userVoted = userVoteOptionId != null;

    return PollModel(
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

      // Poll-specific fields
      options: options,
      totalVotes: totalVotes,
      userVoted: userVoted,
      userVoteOptionId: userVoteOptionId,
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

      // Poll-specific data (nested object)
      'poll': {
        'options': options
            .map(
              (option) => {
                'id': option.id,
                'text': option.text,
                'vote_count': option.votes,
                'percentage': option.percentage,
              },
            )
            .toList(),
        'total_votes': totalVotes,
        'user_voted': userVoted,
        'user_vote_option_id': userVoteOptionId,
      },
    };
  }

  // Updated mockData method
  static PollModel mockData({
    String? id,
    String? title,
    String? body,
    String? userId,
    DateTime? createdAt,
    PostStatus status = PostStatus.published,
  }) {
    return PollModel(
      // PostModel fields
      id: id ?? 'poll_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId ?? 'user_123',
      title: title ?? 'Sample Poll',
      body: body ?? 'This is a sample poll description.',
      createdAt: createdAt ?? DateTime.now(),
      status: status,
      allowMultipleAnswers: false,
      allowAddingOptions: false,
      showResultsBeforeVoting: true,
      authorUsername: 'test_user',

      // Poll-specific fields
      totalVotes: 5,
      options: [
        OptionModel(id: 'option_1', text: 'Option 1', votes: 3, percentage: 60),
        OptionModel(id: 'option_2', text: 'Option 2', votes: 2, percentage: 40),
      ],
      userVoted: true,
      userVoteOptionId: 'option_1',
    );
  }

  // Helper methods
  OptionModel? getUserVotedOption() {
    if (!userVoted || userVoteOptionId == null) return null;
    try {
      return options.firstWhere((option) => option.id == userVoteOptionId);
    } catch (e) {
      return null;
    }
  }

  bool get hasExpired => isExpired;
  bool get canVote => !userVoted && !hasExpired;
  bool get canSeeResults => showResultsBeforeVoting || userVoted || hasExpired;
}
