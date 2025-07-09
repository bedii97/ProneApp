class QuizResultModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String colorValue;

  const QuizResultModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.colorValue,
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
      colorValue: colorValue ?? this.colorValue,
    );
  }

  // ✅ toJson metodu
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'colorValue': colorValue,
    };
  }

  // ✅ fromJson metodu
  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      colorValue: json['colorValue'] as String,
    );
  }
}
