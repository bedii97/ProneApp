import 'package:flutter/material.dart';

class QuizResultsAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const QuizResultsAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add),
        label: const Text('Yeni sonuç ekle'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.blue[300]!),
        ),
      ),
    );
  }
}
