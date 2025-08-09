import 'package:flutter/material.dart';

class Resultscoring extends StatelessWidget {
  final String questionId;
  final String optionId;
  final String resultId;
  final String resultTitle;
  final Color resultColor;
  final int currentPoints;
  final Function(String, String, String, int) updateScoring;
  const Resultscoring({
    super.key,
    required this.questionId,
    required this.optionId,
    required this.resultId,
    required this.resultTitle,
    required this.resultColor,
    required this.currentPoints,
    required this.updateScoring,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: resultColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: resultColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            resultTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: resultColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final points = index;
              final isSelected = currentPoints == points;

              return GestureDetector(
                onTap: () =>
                    updateScoring(questionId, optionId, resultId, points),
                child: Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? resultColor : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: isSelected ? const Icon(Icons.check, size: 24) : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          Text('$currentPoints puan', style: TextStyle()),
        ],
      ),
    );
  }
}
