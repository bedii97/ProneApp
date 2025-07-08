import 'package:flutter/material.dart';

class QuizQuestionHeader extends StatelessWidget {
  final int questionNumber;
  final VoidCallback? onRemove;

  const QuizQuestionHeader({
    super.key,
    required this.questionNumber,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Soru $questionNumber',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (onRemove != null)
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
      ],
    );
  }
}
