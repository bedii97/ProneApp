import 'package:flutter/material.dart';

class QuizPreviewHeader extends StatelessWidget {
  final String title;
  final String description;
  final bool hasTimeLimit;
  final DateTime? expiresAt;

  const QuizPreviewHeader({
    super.key,
    required this.title,
    required this.description,
    required this.hasTimeLimit,
    this.expiresAt,
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
                const Icon(Icons.preview, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Quiz Önizlemesi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quiz Title
            Text(
              title.isEmpty ? 'Quiz Başlığı' : title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: title.isEmpty ? Colors.grey : null,
              ),
            ),
            const SizedBox(height: 8),

            // Quiz Description
            if (description.isNotEmpty) ...[
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
            ],

            // Time Limit Info
            if (hasTimeLimit && expiresAt != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bu quiz ${expiresAt!.day}/${expiresAt!.month}/${expiresAt!.year} tarihinde sona erecek',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
