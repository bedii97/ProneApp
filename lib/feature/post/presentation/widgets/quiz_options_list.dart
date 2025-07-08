import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_option_item.dart';

class QuizOptionsList extends StatelessWidget {
  final QuizQuestion question;
  final int questionIndex;
  final VoidCallback onOptionsChanged;

  const QuizOptionsList({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.onOptionsChanged,
  });

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
              context.read<CreateQuizCubit>().updateOption(
                questionIndex,
                index,
                value,
              );
            },
            onRemove: () {
              context.read<CreateQuizCubit>().removeOption(
                questionIndex,
                index,
              );
              onOptionsChanged();
            },
          );
        }).toList(),

        // Add option button
        TextButton.icon(
          onPressed: () {
            context.read<CreateQuizCubit>().addOption(questionIndex);
            onOptionsChanged();
          },
          icon: const Icon(Icons.add_circle),
          label: const Text('Seçenek Ekle'),
        ),
      ],
    );
  }
}
