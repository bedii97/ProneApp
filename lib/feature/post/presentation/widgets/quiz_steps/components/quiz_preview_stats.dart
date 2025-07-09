import 'package:flutter/material.dart';

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

            // Quiz Ready Status
            _buildReadyStatus(),
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
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

  Widget _buildReadyStatus() {
    final isReady = questionCount >= 1 && resultCount >= 2;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isReady ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isReady ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isReady ? Icons.check_circle : Icons.warning,
            color: isReady ? Colors.green[600] : Colors.orange[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReady ? 'Quiz Hazır!' : 'Quiz Tamamlanmadı',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isReady ? Colors.green[700] : Colors.orange[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isReady
                      ? 'Quiz yayınlamaya hazır'
                      : 'En az 1 soru ve 2 sonuç gerekli',
                  style: TextStyle(
                    fontSize: 12,
                    color: isReady ? Colors.green[600] : Colors.orange[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
