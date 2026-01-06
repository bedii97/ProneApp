class QuizUserResultModel {
  final String? title;
  final String? description;
  final String? imageUrl;

  const QuizUserResultModel({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory QuizUserResultModel.fromJson(Map<String, dynamic> json) {
    return QuizUserResultModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'image_url': imageUrl};
  }
}
