import 'package:flutter/material.dart';

class QuizPreviewActions extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onSimulate;

  const QuizPreviewActions({
    super.key,
    required this.onReset,
    required this.onSimulate,
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
                const Icon(Icons.settings, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'Önizleme Seçenekleri',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Sıfırla'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSimulate,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Test Et'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
