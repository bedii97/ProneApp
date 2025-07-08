import 'package:flutter/material.dart';

class QuizQuestionTextInput extends StatelessWidget {
  final Function(String) onChanged;
  final String? initialValue;

  const QuizQuestionTextInput({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: const InputDecoration(
        labelText: 'Soru metni',
        border: OutlineInputBorder(),
        hintText: 'Sorunuzu buraya yazın...',
      ),
      maxLines: 2,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Soru metni boş olamaz';
        }
        return null;
      },
    );
  }
}
