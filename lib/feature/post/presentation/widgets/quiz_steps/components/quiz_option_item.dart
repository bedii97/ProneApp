import 'package:flutter/material.dart';

class QuizOptionItem extends StatelessWidget {
  final int index;
  final String value;
  final bool canRemove;
  final Function(String) onChanged;
  final VoidCallback onRemove;

  const QuizOptionItem({
    super.key,
    required this.index,
    required this.value,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: value,
              decoration: InputDecoration(
                labelText: 'Seçenek ${index + 1}',
                border: const OutlineInputBorder(),
                hintText: 'Cevap seçeneğini yazın...',
              ),
              onChanged: onChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Seçenek boş olamaz';
                }
                return null;
              },
            ),
          ),
          if (canRemove)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.remove_circle, color: Colors.red),
            ),
        ],
      ),
    );
  }
}
