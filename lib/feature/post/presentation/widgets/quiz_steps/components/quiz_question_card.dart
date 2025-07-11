import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_question_header.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_question_text_input.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_options_list.dart';

class QuizQuestionCard extends StatelessWidget {
  final QuizQuestionModel question;
  final int questionNumber;
  final VoidCallback? onRemove;
  final Function(String) onQuestionChanged;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    this.onRemove,
    required this.onQuestionChanged,
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
            QuizQuestionHeader(
              questionNumber: questionNumber,
              onRemove: onRemove,
            ),
            const SizedBox(height: 12),

            QuizQuestionTextInput(
              initialValue: question.questionText,
              onChanged: onQuestionChanged,
            ),
            const SizedBox(height: 16),

            QuizOptionsList(
              question: question,
              questionIndex: questionNumber - 1,
            ),
          ],
        ),
      ),
    );
  }
}
