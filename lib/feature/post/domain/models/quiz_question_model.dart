import 'package:prone/feature/post/domain/models/quiz_option_model.dart';

class QuizQuestionModel {
  final String id;
  final String questionText;
  final int orderIndex; // Soru sırası (database'de var)
  final List<QuizOptionModel>
  options; // Değişti: List<String> -> List<QuizOptionModel>

  const QuizQuestionModel({
    required this.id,
    required this.questionText,
    required this.orderIndex,
    required this.options,
  });

  QuizQuestionModel copyWith({
    String? id,
    String? questionText,
    int? orderIndex,
    List<QuizOptionModel>? options,
  }) {
    return QuizQuestionModel(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      orderIndex: orderIndex ?? this.orderIndex,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText, // Database field name
      'order_index': orderIndex,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    // Options'ları parse et
    final optionsData = json['quiz_options'] as List<dynamic>? ?? [];
    final options = optionsData.map((optionData) {
      return QuizOptionModel.fromJson(optionData);
    }).toList();

    return QuizQuestionModel(
      id: json['id'] as String,
      questionText: json['question_text'] as String,
      orderIndex: json['order_index'] as int? ?? 0,
      options: options,
    );
  }

  // Equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizQuestionModel &&
        other.id == id &&
        other.questionText == questionText &&
        other.orderIndex == orderIndex &&
        _listEquals(other.options, options);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        questionText.hashCode ^
        orderIndex.hashCode ^
        options.hashCode;
  }

  @override
  String toString() {
    return 'QuizQuestionModel(id: $id, questionText: $questionText, orderIndex: $orderIndex, options: ${options.length} options)';
  }

  // Helper methods
  QuizOptionModel? getOptionById(String optionId) {
    try {
      return options.firstWhere((option) => option.id == optionId);
    } catch (e) {
      return null;
    }
  }

  List<String> get optionIds => options.map((option) => option.id).toList();

  bool hasOptionWithId(String optionId) {
    return options.any((option) => option.id == optionId);
  }

  int get optionCount => options.length;

  // Get all result IDs that any option maps to
  Set<String> getAllMappedResultIds() {
    final Set<String> resultIds = {};
    for (final option in options) {
      resultIds.addAll(option.mappedResultIds);
    }
    return resultIds;
  }

  // Helper function for list equality
  bool _listEquals(List<QuizOptionModel> list1, List<QuizOptionModel> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
