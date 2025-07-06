import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz_question_model.dart';

class QuizQuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final int questionNumber;
  final VoidCallback? onRemove;
  final Function(String) onQuestionChanged;
  final VoidCallback onOptionsChanged;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    this.onRemove,
    required this.onQuestionChanged,
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Soru başlığı ve silme butonu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Soru $questionNumber',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Soru metni input
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Soru metni',
                border: OutlineInputBorder(),
                hintText: 'Sorunuzu buraya yazın...',
              ),
              maxLines: 2,
              onChanged: onQuestionChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Soru metni boş olamaz';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Cevap seçenekleri başlığı
            const Text(
              'Cevap Seçenekleri',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // Cevap seçenekleri listesi
            ...question.options.asMap().entries.map((entry) {
              int index = entry.key;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Seçenek ${index + 1}',
                          border: const OutlineInputBorder(),
                          hintText: 'Cevap seçeneğini yazın...',
                        ),
                        onChanged: (value) {
                          question.options[index] = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seçenek boş olamaz';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (question.options.length > 1)
                      IconButton(
                        onPressed: () => _removeOption(index),
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),

            // Seçenek ekleme butonu
            TextButton.icon(
              onPressed: _addOption,
              icon: const Icon(Icons.add_circle),
              label: const Text('Seçenek Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
