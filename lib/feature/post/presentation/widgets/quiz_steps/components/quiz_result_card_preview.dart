import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz_result_model.dart';

class QuizResultCardPreview extends StatelessWidget {
  final QuizResultModel result;

  const QuizResultCardPreview({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final title = result.title;
    final description = result.description;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Önizleme',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_getIconData(result.icon), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty ? 'Başlık girilmedi' : title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: title.isEmpty ? Colors.grey : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description.isEmpty ? 'Açıklama girilmedi' : description,
                      style: TextStyle(
                        fontSize: 14,
                        color: description.isEmpty
                            ? Colors.grey
                            : Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
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

    return iconMap[iconName] ?? Icons.help;
  }
}
