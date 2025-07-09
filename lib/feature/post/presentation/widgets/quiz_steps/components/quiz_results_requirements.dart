import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz_result_model.dart';

class QuizResultsRequirements extends StatelessWidget {
  final List<QuizResultModel> results;

  const QuizResultsRequirements({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final hasEnoughResults = results.length >= 2;
    final hasValidTitles = results.every((r) => r.title.trim().isNotEmpty);
    final hasValidDescriptions = results.every(
      (r) => r.description.trim().isNotEmpty,
    );
    final isComplete =
        hasEnoughResults && hasValidTitles && hasValidDescriptions;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isComplete ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isComplete ? Icons.check_circle : Icons.info_outline,
                color: isComplete ? Colors.green[600] : Colors.orange[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isComplete ? 'Tamamlandı!' : 'Eksik gereksinimler',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isComplete ? Colors.green[700] : Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _RequirementItem(
            text: 'En az 2 sonuç',
            isCompleted: hasEnoughResults,
          ),
          _RequirementItem(
            text: 'Tüm başlıklar doldurulmuş',
            isCompleted: hasValidTitles,
          ),
          _RequirementItem(
            text: 'Tüm açıklamalar doldurulmuş',
            isCompleted: hasValidDescriptions,
          ),
        ],
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  final bool isCompleted;

  const _RequirementItem({required this.text, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check : Icons.radio_button_unchecked,
            size: 16,
            color: isCompleted ? Colors.green[600] : Colors.grey[500],
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isCompleted ? Colors.green[700] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
