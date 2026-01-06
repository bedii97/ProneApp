import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_result_model.dart';

class QuizPreviewResults extends StatelessWidget {
  final List<QuizResultModel> results;

  const QuizPreviewResults({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Olası Sonuçlar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...results.map((result) => _buildResultCard(result)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(QuizResultModel result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconData(result.icon ?? 'emoji_events'),
              color: Colors.blue[700],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'emoji_events': Icons.emoji_events,
      'palette': Icons.palette,
      'analytics': Icons.analytics,
      'groups': Icons.groups,
      'psychology': Icons.psychology,
      'favorite': Icons.favorite,
      'star': Icons.star,
      'local_fire_department': Icons.local_fire_department,
      'lightbulb': Icons.lightbulb,
      'bolt': Icons.bolt,
      'nature_people': Icons.nature_people,
      'celebration': Icons.celebration,
    };
    return iconMap[iconName] ?? Icons.help_outline;
  }
}
