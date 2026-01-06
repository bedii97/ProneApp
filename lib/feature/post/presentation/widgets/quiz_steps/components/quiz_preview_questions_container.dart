import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_question_model.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_preview_question.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_preview_navigation.dart';

class QuizPreviewQuestionsContainer extends StatelessWidget {
  final List<QuizQuestionModel> questions;
  final int currentQuestionIndex;
  final Map<int, int> selectedAnswers;
  final Function(int) onAnswerSelected;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const QuizPreviewQuestionsContainer({
    super.key,
    required this.questions,
    required this.currentQuestionIndex,
    required this.selectedAnswers,
    required this.onAnswerSelected,
    this.onPrevious,
    this.onNext,
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
                const Icon(Icons.quiz, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Sorular Önizlemesi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${currentQuestionIndex + 1}/${questions.length}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Bar
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 20),

            // Current Question
            QuizPreviewQuestion(
              question: questions[currentQuestionIndex],
              questionNumber: currentQuestionIndex + 1,
              selectedAnswer: selectedAnswers[currentQuestionIndex],
              onAnswerSelected: onAnswerSelected,
            ),
            const SizedBox(height: 20),

            // Navigation Buttons
            QuizPreviewNavigation(
              currentIndex: currentQuestionIndex,
              totalQuestions: questions.length,
              onPrevious: onPrevious,
              onNext: onNext,
            ),
          ],
        ),
      ),
    );
  }
}
