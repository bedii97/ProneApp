import 'package:flutter/material.dart';

class QuizPreviewDialog extends StatelessWidget {
  final Map<String, dynamic> result;

  const QuizPreviewDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.emoji_events, color: Colors.amber),
          SizedBox(width: 8),
          Text('Quiz Sonucu'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result['title'] as String,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            result['description'] as String,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: const Text(
              'Bu bir simülasyon sonucudur. Gerçek quiz\'de puan sistemine göre sonuç belirlenir.',
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kapat'),
        ),
      ],
    );
  }

  static void show(BuildContext context, Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (context) => QuizPreviewDialog(result: result),
    );
  }
}
