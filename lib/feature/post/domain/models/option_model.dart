import 'package:prone/feature/post/domain/models/create_poll_model.dart';

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

  // ✅ Eksik olan toJson() metodu
  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'votes': votes, 'percentage': percentage};
  }

  // ✅ Bonus: copyWith metodu da ekleyelim
  OptionModel copyWith({
    String? id,
    String? text,
    int? votes,
    double? percentage,
  }) {
    return OptionModel(
      id: id ?? this.id,
      text: text ?? this.text,
      votes: votes ?? this.votes,
      percentage: percentage ?? this.percentage,
    );
  }
}
