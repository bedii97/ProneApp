import 'package:flutter/material.dart';

class QuizPreviewNavigation extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const QuizPreviewNavigation({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(onPressed: onPrevious, child: const Text('Önceki')),
        TextButton(onPressed: onNext, child: const Text('Sonraki')),
      ],
    );
  }
}
