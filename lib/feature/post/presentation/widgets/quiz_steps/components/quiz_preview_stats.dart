import 'package:flutter/material.dart';
import 'package:prone/core/extensions/color_extension.dart';

class QuizPreviewStats extends StatelessWidget {
  final int questionCount;
  final int resultCount;

  const QuizPreviewStats({
    super.key,
    required this.questionCount,
    required this.resultCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Quiz Özeti',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Soru Sayısı',
                    questionCount.toString(),
                    Icons.quiz,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Sonuç Sayısı',
                    resultCount.toString(),
                    Icons.emoji_events,
                    Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacityD(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacityD(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
