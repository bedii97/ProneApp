import 'package:prone/feature/post/domain/models/create_poll_model.dart';

enum PostType { poll, quiz }

enum PostStatus { draft, published, archived, deleted }

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

class PostModel {
  final String? id;
  final String title;
  final String? body;
  final List<String>? imageUrls;
  final String userId;
  final DateTime createdAt;
  final int totalVotes;
  final List<OptionModel> options;
  final bool userVoted;
  final String userVoteOption;
  final PostType type;

  PostModel({
    this.id,
    required this.title,
    this.body,
    this.imageUrls,
    required this.userId,
    required this.createdAt,
    required this.totalVotes,
    required this.options,
    required this.userVoted,
    required this.userVoteOption,
    this.type = PostType.poll,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: PostType.values.firstWhere(
        (e) => e.name == (json['post_type'] as String? ?? 'poll'),
        orElse: () => PostType.poll,
      ),
      title: json['title'] as String,
      body: json['body'] as String?,
      imageUrls: json['image_urls'] != null
          ? List<String>.from(json['image_urls'] as List)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      totalVotes: json['total_votes'] as int? ?? 0,
      options: (json['options'] as List<dynamic>).map((option) {
        return OptionModel.fromJson(option as Map<String, dynamic>);
      }).toList(),
      userVoted: json['user_voted'] as bool? ?? false,
      userVoteOption: json['user_vote_option'] as String? ?? '',
    );
  }

  ///////////////MOCK DATA FOR TESTING/////////////
  static PostModel mockPost = PostModel(
    id: '1',
    title: 'Hangi programlama dili daha popüler?',
    body:
        'Günümüzde yazılım geliştirme dünyasında hangi programlama dilinin daha popüler olduğunu merak ediyorum. Sizce hangisi?',
    imageUrls: [
      'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=800&h=400&fit=crop',
      'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=800&h=400&fit=crop',
      'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=800&h=400&fit=crop',
      'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=800&h=400&fit=crop',
    ],
    userId: 'user123',
    createdAt: DateTime.now(),
    totalVotes: 10,
    options: [
      OptionModel(id: '1', text: 'JavaScript', votes: 5, percentage: 50.0),
      OptionModel(id: '2', text: 'Python', votes: 3, percentage: 30.0),
      OptionModel(id: '3', text: 'Dart/Flutter', votes: 2, percentage: 20.0),
    ],
    userVoted: true,
    userVoteOption: '1',
    type: PostType.poll,
  );

  static PostModel mockPost2 = PostModel(
    id: '2',
    title: 'En iyi mobil uygulama geliştirme platformu?',
    body: 'Mobil uygulama geliştirmek için hangi platform daha avantajlı?',
    imageUrls: [
      'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&h=400&fit=crop',
    ],
    userId: 'user456',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    totalVotes: 5,
    options: [
      OptionModel(id: '1', text: 'Flutter', votes: 2, percentage: 40.0),
      OptionModel(id: '2', text: 'React Native', votes: 3, percentage: 60.0),
    ],
    userVoted: false,
    userVoteOption: '',
    type: PostType.poll,
  );

  static PostModel mockPost3 = PostModel(
    id: '3',
    title: 'Favori IDE\'niz hangisi?',
    body: 'Kod yazarken hangi geliştirme ortamını tercih ediyorsunuz?',
    userId: 'user789',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    totalVotes: 0,
    options: [
      OptionModel(id: '1', text: 'VS Code', votes: 0, percentage: 50.0),
      OptionModel(id: '2', text: 'Android Studio', votes: 0, percentage: 50.0),
    ],
    userVoted: true,
    userVoteOption: '2',
    type: PostType.poll,
  );
}
