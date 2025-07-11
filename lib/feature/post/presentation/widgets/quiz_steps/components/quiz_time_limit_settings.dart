import 'package:flutter/material.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_date_time_picker.dart';

class QuizTimeLimitSettings extends StatelessWidget {
  final bool hasTimeLimit;
  final DateTime? expiresAt;
  final ValueChanged<bool> onTimeLimitChanged;
  final VoidCallback onDateTimeSelect;

  const QuizTimeLimitSettings({
    super.key,
    required this.hasTimeLimit,
    required this.expiresAt,
    required this.onTimeLimitChanged,
    required this.onDateTimeSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Süre Ayarları',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Süre sınırı ekle'),
              subtitle: Text(
                hasTimeLimit
                    ? 'Quiz belirli bir tarihte sona erecek'
                    : 'Quiz süresiz olacak',
              ),
              value: hasTimeLimit,
              onChanged: onTimeLimitChanged,
            ),

            if (hasTimeLimit) ...[
              const SizedBox(height: 16),
              QuizDateTimePicker(
                selectedDate: expiresAt,
                onTap: onDateTimeSelect,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
