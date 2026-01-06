class QuizResultModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl; // Database'de image_url olarak var

  // UI için ek özellikler (isteğe bağlı)
  final String? icon;
  final String? colorValue;

  const QuizResultModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.icon,
    this.colorValue,
  });

  QuizResultModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? icon,
    String? colorValue,
  }) {
    return QuizResultModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl, // Database field name
      'icon': icon,
      'color_value': colorValue,
    };
  }

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      icon: json['icon'] as String?,
      colorValue: json['color_value'] as String?,
    );
  }

  // Equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizResultModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.icon == icon &&
        other.colorValue == colorValue;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        icon.hashCode ^
        colorValue.hashCode;
  }

  @override
  String toString() {
    return 'QuizResultModel(id: $id, title: $title, description: $description)';
  }

  // Helper methods
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasIcon => icon != null && icon!.isNotEmpty;
  bool get hasColor => colorValue != null && colorValue!.isNotEmpty;
  bool get hasDescription => description.isNotEmpty;
}
