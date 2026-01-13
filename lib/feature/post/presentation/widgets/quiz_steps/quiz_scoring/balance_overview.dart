import 'package:flutter/material.dart';
import 'package:prone/feature/post/presentation/cubits/quiz/create_quiz_state.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/quiz_scoring/helpers/quiz_scoring_helpers.dart';

class BalanceOverview extends StatelessWidget {
  final CreateQuizState state;

  const BalanceOverview({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final totalPoints = _calculateTotalPoints(state);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Puan Dengesi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: state.results.map((result) {
              final resultPoints = state.getTotalPointsForResult(result.id);
              final percentage = totalPoints > 0
                  ? (resultPoints / totalPoints) * 100
                  : 0;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: QuizScoringHelpers.hexToColor(
                      result.colorValue ?? 'FFFFFF',
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: QuizScoringHelpers.hexToColor(
                        result.colorValue ?? 'FFFFFF',
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        result.title.isEmpty
                            ? 'Sonuç ${state.results.indexOf(result) + 1}'
                            : result.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$resultPoints puan',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '%${percentage.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: QuizScoringHelpers.hexToColor(
                            result.colorValue ?? 'FFFFFF',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  int _calculateTotalPoints(CreateQuizState state) {
    return state.scoring.fold<int>(0, (total, scoring) {
      return total +
          scoring.resultPoints.values.fold<int>(
            0,
            (sum, points) => sum + points,
          );
    });
  }
}
