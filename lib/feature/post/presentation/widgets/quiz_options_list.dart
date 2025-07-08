import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_option_item.dart';

class QuizOptionsList extends StatelessWidget {
  final QuizQuestion question;
  final VoidCallback onOptionsChanged;

  const QuizOptionsList({
    super.key,
    required this.question,
    required this.onOptionsChanged,
  });

  void _addOption() {
    question.options.add('');
    onOptionsChanged();
  }

  void _removeOption(int index) {
    if (question.options.length > 1) {
      question.options.removeAt(index);
      onOptionsChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cevap Seçenekleri',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        
        // Options
        ...question.options.asMap().entries.map((entry) {
          int index = entry.key;
          return QuizOptionItem(
            index: index,
            value: entry.value,
            canRemove: question.options.length > 1,
            onChanged: (value) {
              question.options[index] = value;
            },
            onRemove: () => _removeOption(index),
          );
        }).toList(),
        
        // Add option button
        TextButton.icon(
          onPressed: _addOption,
          icon: const Icon(Icons.add_circle),
          label: const Text('Seçenek Ekle'),
        ),
      ],
    );
  }
}