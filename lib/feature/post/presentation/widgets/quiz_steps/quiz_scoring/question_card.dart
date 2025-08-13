// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_state.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/quiz_scoring/option_scoring.dart';

class QuestionCard extends StatelessWidget {
  final QuizQuestionModel question;
  final int questionIndex;
  final CreateQuizState state;
  final Function(String, String, String, int) updateScoring;
  const QuestionCard({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.state,
    required this.updateScoring,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                question.questionText.isEmpty
                    ? 'Soru ${questionIndex + 1}'
                    : question.questionText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ),
            const SizedBox(height: 16),

            ...question.options.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final optionText = entry.value;
              final optionId = 'option_${questionIndex}_$optionIndex';

              return OptionScoring(
                questionId: question.id,
                optionId: optionId,
                optionText: optionText.text,
                optionIndex: optionIndex,
                state: state,
                updateScoring: updateScoring,
              );
            }),
          ],
        ),
      ),
    );
  }
}
