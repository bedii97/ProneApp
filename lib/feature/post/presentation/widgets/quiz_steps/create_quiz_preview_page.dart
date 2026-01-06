import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_result_model.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_state.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/components.dart';

class CreateQuizPreviewPage extends StatefulWidget {
  const CreateQuizPreviewPage({super.key});

  @override
  State<CreateQuizPreviewPage> createState() => _CreateQuizPreviewPageState();
}

class _CreateQuizPreviewPageState extends State<CreateQuizPreviewPage> {
  int currentQuestionIndex = 0;
  Map<int, int> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateQuizCubit, CreateQuizState>(
      builder: (context, state) {
        final questions = state.questions;
        final results = state.results;
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preview Header
                    QuizPreviewHeader(
                      title: state.title,
                      description: state.description,
                      hasTimeLimit: state.hasTimeLimit,
                      expiresAt: state.expiresAt,
                    ),
                    const SizedBox(height: 24),

                    // Quiz Stats
                    QuizPreviewStats(
                      questionCount: questions.length,
                      resultCount: results.length,
                    ),
                    const SizedBox(height: 24),

                    // Quiz Questions Preview
                    QuizPreviewQuestionsContainer(
                      questions: questions,
                      currentQuestionIndex: currentQuestionIndex,
                      selectedAnswers: selectedAnswers,
                      onAnswerSelected: (index) {
                        setState(() {
                          selectedAnswers[currentQuestionIndex] = index;
                        });
                      },
                      onPrevious: currentQuestionIndex > 0
                          ? () {
                              setState(() {
                                currentQuestionIndex--;
                              });
                            }
                          : null,
                      onNext: currentQuestionIndex < questions.length - 1
                          ? () {
                              setState(() {
                                currentQuestionIndex++;
                              });
                            }
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Quiz Results Preview
                    QuizPreviewResults(results: results),
                    const SizedBox(height: 24),

                    // Preview Actions
                    QuizPreviewActions(
                      onReset: () {
                        setState(() {
                          currentQuestionIndex = 0;
                          selectedAnswers.clear();
                        });
                      },
                      onSimulate: () => _simulateQuiz(results),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _simulateQuiz(List<QuizResultModel> results) {
    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Henüz sonuç eklenmemiş'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final random = DateTime.now().millisecondsSinceEpoch % results.length;
    final simulatedResult = results[random];

    QuizPreviewDialog.show(context, simulatedResult);
  }
}
