import 'package:prone/feature/post/domain/models/poll/create_poll_model.dart';

class OptionModel {
  final String id;
  final String text;
  final int votes;
  final double percentage;

  const OptionModel({
    required this.id,
    required this.text,
    required this.votes,
    required this.percentage,
  });

  // copyWith metodu (eksikti)
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

  // toJson metodu (eksikti)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'vote_count': votes,
      'percentage': percentage,
    };
  }

  // fromJson - JSON formatına uygun güncelleme
  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      votes: json['vote_count'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // fromCreateOptionModel - mevcut metodun güncellenmesi
  factory OptionModel.fromCreateOptionModel({
    required String optionId,
    required CreateOptionModel createOption,
    int votes = 0,
    double percentage = 0.0,
  }) {
    return OptionModel(
      id: optionId,
      text: createOption.text,
      votes: votes,
      percentage: percentage,
    );
  }

  // Equality and hashCode (kullanışlı olabilir)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OptionModel &&
        other.id == id &&
        other.text == text &&
        other.votes == votes &&
        other.percentage == percentage;
  }

  @override
  int get hashCode {
    return id.hashCode ^ text.hashCode ^ votes.hashCode ^ percentage.hashCode;
  }

  @override
  String toString() {
    return 'OptionModel(id: $id, text: $text, votes: $votes, percentage: $percentage)';
  }

  // Helper methods
  bool get hasVotes => votes > 0;
  String get percentageText => '${percentage.toStringAsFixed(1)}%';
}
