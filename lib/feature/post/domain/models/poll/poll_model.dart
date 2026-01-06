import 'package:prone/feature/post/domain/models/poll/option_model.dart';
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
    super.id, //
    required super.userId, //
    required super.title, //
    super.body, //
    super.imageUrls,
    required super.createdAt, //
    super.updatedAt, //
    super.status = PostStatus.published, //
    required super.allowMultipleAnswers, //
    required super.allowAddingOptions, //
    required super.showResultsBeforeVoting, //
    super.expiresAt, //
    required super.authorUsername,
    super.authorAvatarUrl,

    // Poll-specific fields
    required this.options, //
    required this.totalVotes,
    required this.userVoted,
    this.userVoteOptionId,
  }) : super(type: PostType.poll);

  factory PollModel.fromJson(Map<String, dynamic> json) {
    // 1. Author Bilgisi
    final usersData = json['users'] as Map<String, dynamic>? ?? {};

    // 2. Seçenekleri ve Yüzdeleri Hesapla (Yardımcı Metot Kullanımı)
    final rawOptions = json['poll_options'] as List<dynamic>? ?? [];
    final processedOptions = _calculateOptionsWithPercentages(rawOptions);

    // 3. Toplam Oy Sayısını Hesapla (Fold ile)
    final totalVotes = processedOptions.fold<int>(
      0,
      (sum, option) => sum + option.votes,
    );

    // 4. Kullanıcının Oy Durumu (Current User Vote)
    // Edge function veya join query'den gelen 'user_votes' listesini kontrol et
    final userVotesData = json['user_votes'] as List<dynamic>? ?? [];
    String? userVoteOptionId;

    if (userVotesData.isNotEmpty) {
      final firstVote = userVotesData.first as Map<String, dynamic>?;
      userVoteOptionId = firstVote?['option_id'] as String?;
    }

    final userVoted = userVoteOptionId != null;

    return PollModel(
      // --- PostModel Base Fields ---
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String?,
      // Tarihleri güvenli parse et
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      // Enum dönüşümü (Güvenli)
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

      // --- PollModel Specific Fields ---
      options: processedOptions,
      totalVotes: totalVotes,
      userVoted: userVoted,
      userVoteOptionId: userVoteOptionId,
    );
  }

  /// Seçenekleri işleyen, oy sayılarını toplayan ve yüzdeleri hesaplayan
  /// yardımcı metot. Kod karmaşasını önler.
  static List<OptionModel> _calculateOptionsWithPercentages(
    List<dynamic> rawOptions,
  ) {
    List<OptionModel> tempOptions = [];
    int localTotal = 0;

    // 1. Adım: Ham veriden OptionModel oluştur ve toplam oyu bul
    for (final optionData in rawOptions) {
      // Supabase count sorgusundan gelen veri yapısı:
      // user_votes: [{'count': 5}] şeklinde bir liste döner.
      final votesList = optionData['user_votes'] as List<dynamic>? ?? [];

      final int voteCount = votesList.isNotEmpty
          ? (votesList.first['count'] as int? ?? 0)
          : 0;

      localTotal += voteCount;

      tempOptions.add(
        OptionModel(
          id: optionData['id'] as String,
          text: optionData['option_text'] as String,
          votes: voteCount,
          percentage: 0.0, // Geçici değer, aşağıda güncellenecek
        ),
      );
    }

    // 2. Adım: Yüzdeleri hesapla ve güncelle
    // Eğer hiç oy yoksa (localTotal == 0), tüm yüzdeler 0 kalır.
    if (localTotal == 0) return tempOptions;

    return tempOptions.map((opt) {
      final double percentage = (opt.votes / localTotal) * 100;
      return opt.copyWith(percentage: percentage);
    }).toList();
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

  // CopyWith
  PollModel copyWith({
    // PostModel fields
    String? id,
    String? userId,
    String? title,
    String? body,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    PostStatus? status,
    bool? allowMultipleAnswers,
    bool? allowAddingOptions,
    bool? showResultsBeforeVoting,
    DateTime? expiresAt,
    String? authorUsername,
    String? authorAvatarUrl,

    // Poll-specific fields
    List<OptionModel>? options,
    int? totalVotes,
    bool? userVoted,
    String? userVoteOptionId,
  }) {
    return PollModel(
      // PostModel fields
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      allowMultipleAnswers: allowMultipleAnswers ?? this.allowMultipleAnswers,
      allowAddingOptions: allowAddingOptions ?? this.allowAddingOptions,
      showResultsBeforeVoting:
          showResultsBeforeVoting ?? this.showResultsBeforeVoting,
      expiresAt: expiresAt ?? this.expiresAt,
      authorUsername: authorUsername ?? this.authorUsername,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,

      // Poll-specific fields
      options: options ?? this.options,
      totalVotes: totalVotes ?? this.totalVotes,
      userVoted: userVoted ?? this.userVoted,
      userVoteOptionId: userVoteOptionId ?? this.userVoteOptionId,
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

  bool get hasExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get canVote => !userVoted && !hasExpired;
  bool get canSeeResults => showResultsBeforeVoting || userVoted || hasExpired;
}
