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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'colorValue': colorValue,
    };
  }

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    try {
      return QuizResultModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        icon: json['icon'] as String? ?? 'emoji_events', // ✅ Default value
        colorValue:
            json['color_value'] as String? ??
            '#FFFFFF', // ✅ Default value, snake_case
      );
    } catch (e) {
      rethrow;
    }
  }

  static QuizResultModel mockData() {
    return QuizResultModel(
      id: "1",
      title: "Mock Result",
      description: "This is a mock result.",
      icon: "emoji_events",
      colorValue: "#FF0000",
    );
  }
}
