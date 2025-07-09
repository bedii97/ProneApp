import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz_result_model.dart';

class QuizResultCardForm extends StatelessWidget {
  final QuizResultModel result;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;

  const QuizResultCardForm({
    super.key,
    required this.result,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Result Title
        TextFormField(
          initialValue: result.title,
          decoration: const InputDecoration(
            hintText: 'Örn: Yaratıcı Tip',
            border: OutlineInputBorder(),
            helperText: 'Kullanıcıya gösterilecek ana başlık',
            counterText: '',
          ),
          maxLength: 50,
          onChanged: onTitleChanged,
        ),
        const SizedBox(height: 16),

        // Result Description
        TextFormField(
          initialValue: result.description,
          decoration: const InputDecoration(
            hintText: 'Bu sonuca uyan kişinin özelliklerini açıklayın...',
            border: OutlineInputBorder(),
            helperText: 'Bu kişilik tipinin detaylı açıklaması',
            counterText: '',
          ),
          maxLines: 4,
          maxLength: 300,
          onChanged: onDescriptionChanged,
        ),
        const SizedBox(height: 16),

        // Image Placeholder (for future feature)
        // Container(
        //   width: double.infinity,
        //   height: 100,
        //   decoration: BoxDecoration(
        //     color: Colors.grey[100],
        //     borderRadius: BorderRadius.circular(8),
        //     border: Border.all(
        //       color: Colors.grey[300]!,
        //       style: BorderStyle.solid,
        //     ),
        //   ),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Icon(Icons.image_outlined, size: 32, color: Colors.grey[400]),
        //       const SizedBox(height: 8),
        //       Text(
        //         'Sonuç görseli (yakında)',
        //         style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
