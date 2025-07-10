import 'package:flutter/material.dart';
import 'package:prone/core/utils/quiz_validator.dart';

class QuizQuestionTextInput extends StatelessWidget {
  final Function(String) onChanged;
  final String? initialValue;

  const QuizQuestionTextInput({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Sorunuzu buraya yazın...',
      ),
      maxLines: 2,
      onChanged: onChanged,
      validator: QuizValidator.validateQuizQuestion,
    );
  }
}
