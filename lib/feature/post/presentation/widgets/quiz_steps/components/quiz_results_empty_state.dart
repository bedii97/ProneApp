import 'package:flutter/material.dart';

class QuizResultsEmptyState extends StatelessWidget {
  final VoidCallback onAddResult;

  const QuizResultsEmptyState({super.key, required this.onAddResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'İlk sonucunuzu ekleyin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Quiz için en az 2 farklı sonuç gereklidir',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAddResult,
            icon: const Icon(Icons.add),
            label: const Text('İlk sonucu ekle'),
          ),
        ],
      ),
    );
  }
}
