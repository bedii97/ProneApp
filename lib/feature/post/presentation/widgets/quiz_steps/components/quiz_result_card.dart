import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_result_model.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_result_card_form.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_result_card_header.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_result_card_preview.dart';

class QuizResultCard extends StatelessWidget {
  final QuizResultModel result;
  final int index;
  final Function(int, Map<String, dynamic>) onUpdate;
  final Function(int) onDuplicate;
  final Function(int) onDelete;

  const QuizResultCard({
    super.key,
    required this.result,
    required this.index,
    required this.onUpdate,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuizResultCardHeader(
              index: index,
              onDuplicate: () => onDuplicate(index),
              onDelete: () => onDelete(index),
            ),
            const SizedBox(height: 16),

            QuizResultCardForm(
              result: result,
              onTitleChanged: (value) => onUpdate(index, {'title': value}),
              onDescriptionChanged: (value) =>
                  onUpdate(index, {'description': value}),
            ),
            const SizedBox(height: 16),

            QuizResultCardPreview(result: result),
          ],
        ),
      ),
    );
  }
}
