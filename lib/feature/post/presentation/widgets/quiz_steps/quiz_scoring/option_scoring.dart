import 'package:flutter/material.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_state.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/quiz_scoring/helpers/quiz_scoring_helpers.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/quiz_scoring/result_scoring.dart';

class OptionScoring extends StatelessWidget {
  final String questionId;
  final String optionId;
  final String optionText;
  final int optionIndex;
  final CreateQuizState state;
  final Function(String, String, String, int) updateScoring;
  const OptionScoring({
    super.key,
    required this.questionId,
    required this.optionId,
    required this.optionText,
    required this.optionIndex,
    required this.state,
    required this.updateScoring,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            optionText.isEmpty
                ? 'Seçenek ${String.fromCharCode(65 + optionIndex)}'
                : optionText,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.results.map((result) {
              final scoring = state.getScoringForOption(questionId, optionId);
              final currentPoints = scoring?.getPointsForResult(result.id) ?? 0;

              return Resultscoring(
                questionId: questionId,
                optionId: optionId,
                resultId: result.id,
                resultTitle: result.title.isEmpty
                    ? 'Sonuç ${state.results.indexOf(result) + 1}'
                    : result.title,
                resultColor: QuizScoringHelpers.hexToColor(result.colorValue),
                currentPoints: currentPoints,
                updateScoring: updateScoring,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
