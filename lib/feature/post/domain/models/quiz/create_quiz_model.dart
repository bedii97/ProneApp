class CreateQuizModel {
  final String title;
  final String? body;
  final bool allowMultipleAnswers;
  final bool allowAddingOptions;
  final bool showResultsBeforeVoting;
  final DateTime? expiresAt;
  final List<QuizResultInput> results;
  final List<QuizQuestionInput> questions;

  const CreateQuizModel({
    required this.title,
    this.body,
    this.allowMultipleAnswers = false,
    this.allowAddingOptions = false,
    this.showResultsBeforeVoting = false,
    this.expiresAt,
    required this.results,
    required this.questions,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'allowMultipleAnswers': allowMultipleAnswers,
    'allowAddingOptions': allowAddingOptions,
    'showResultsBeforeVoting': showResultsBeforeVoting,
    'expiresAt': expiresAt?.toUtc().toIso8601String(),
    'results': results.map((r) => r.toJson()).toList(),
    'questions': questions.map((q) => q.toJson()).toList(),
  };

  List<String> validate() {
    final errors = <String>[];
    if (title.trim().length < 3) errors.add('title_min');
    if (results.isEmpty) errors.add('no_results');
    if (questions.isEmpty) errors.add('no_questions');
    for (var i = 0; i < results.length; i++) {
      if (results[i].title.trim().length < 3) {
        errors.add('result_${i + 1}_title_min');
      }
    }
    for (var qi = 0; qi < questions.length; qi++) {
      final q = questions[qi];
      if (q.text.trim().length < 3) errors.add('question_${qi + 1}_text_min');
      if (q.options.length < 2) errors.add('question_${qi + 1}_options_min');
      for (var oi = 0; oi < q.options.length; oi++) {
        final o = q.options[oi];
        if (o.text.trim().isEmpty) {
          errors.add('question_${qi + 1}_option_${oi + 1}_text_empty');
        }
        // Ensure points keys exist in results list
        for (final key in o.points.keys) {
          if (!results.any((r) => r.title == key)) {
            errors.add(
              'question_${qi + 1}_option_${oi + 1}_points_invalid_result:$key',
            );
          }
        }
      }
    }
    if (expiresAt != null && expiresAt!.isBefore(DateTime.now())) {
      errors.add('expires_in_past');
    }
    return errors;
  }

  CreateQuizModel copyWith({
    String? title,
    String? body,
    bool? allowMultipleAnswers,
    bool? allowAddingOptions,
    bool? showResultsBeforeVoting,
    DateTime? expiresAt,
    List<QuizResultInput>? results,
    List<QuizQuestionInput>? questions,
  }) {
    return CreateQuizModel(
      title: title ?? this.title,
      body: body ?? this.body,
      allowMultipleAnswers: allowMultipleAnswers ?? this.allowMultipleAnswers,
      allowAddingOptions: allowAddingOptions ?? this.allowAddingOptions,
      showResultsBeforeVoting:
          showResultsBeforeVoting ?? this.showResultsBeforeVoting,
      expiresAt: expiresAt ?? this.expiresAt,
      results: results ?? this.results,
      questions: questions ?? this.questions,
    );
  }
}

class QuizResultInput {
  final String title;
  final String? description;
  final String? imageUrl;

  const QuizResultInput({required this.title, this.description, this.imageUrl});

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
  };
}

class QuizQuestionInput {
  final String text;
  final List<QuizOptionInput> options;

  const QuizQuestionInput({required this.text, required this.options});

  Map<String, dynamic> toJson() => {
    'text': text,
    'options': options.map((o) => o.toJson()).toList(),
  };
}

class QuizOptionInput {
  final String text;
  final Map<String, int> points;

  QuizOptionInput({required this.text, Map<String, int>? points})
    : points = Map.unmodifiable(points ?? {});

  Map<String, dynamic> toJson() => {'text': text, 'points': points};

  QuizOptionInput copyWith({String? text, Map<String, int>? points}) {
    return QuizOptionInput(
      text: text ?? this.text,
      points: points ?? Map<String, int>.from(this.points),
    );
  }
}

class CreateQuizOption {
  final String text;
  final Map<String, int> points;

  const CreateQuizOption({required this.text, required this.points});

  Map<String, dynamic> toJson() => {'text': text, 'points': points};

  CreateQuizOption copyWith({String? text, Map<String, int>? points}) {
    return CreateQuizOption(
      text: text ?? this.text,
      points: points ?? this.points,
    );
  }
}

class CreateQuizQuestion {
  final String text;
  final List<CreateQuizOption> options;

  const CreateQuizQuestion({required this.text, required this.options});

  Map<String, dynamic> toJson() => {
    'text': text,
    'options': options.map((option) => option.toJson()).toList(),
  };

  CreateQuizQuestion copyWith({String? text, List<CreateQuizOption>? options}) {
    return CreateQuizQuestion(
      text: text ?? this.text,
      options: options ?? this.options,
    );
  }
}

class CreateQuizResult {
  final String title;
  final String description;
  final String? imageUrl;

  const CreateQuizResult({
    required this.title,
    required this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
  };

  CreateQuizResult copyWith({
    String? title,
    String? description,
    String? imageUrl,
  }) {
    return CreateQuizResult(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
