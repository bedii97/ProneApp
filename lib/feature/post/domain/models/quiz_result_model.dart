class QuizResultModel {
  final String id;
  final String title;
  final String description;
  final String icon;

  const QuizResultModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  QuizResultModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    String? colorValue,
  }) {
    return QuizResultModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }
}
