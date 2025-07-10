import 'package:flutter/material.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_preview_header.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_preview_stats.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_preview_questions_container.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_preview_results.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_preview_actions.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_preview_dialog.dart';

class CreateQuizPreviewScreen extends StatefulWidget {
  const CreateQuizPreviewScreen({super.key});

  @override
  State<CreateQuizPreviewScreen> createState() =>
      _CreateQuizPreviewScreenState();
}

class _CreateQuizPreviewScreenState extends State<CreateQuizPreviewScreen> {
  int currentQuestionIndex = 0;
  Map<int, int> selectedAnswers = {};

  // Mock Data
  final _mockQuizData = {
    'title': 'Hangi Kahvesın?',
    'description':
        'Kahve tercihlerinize göre kişiliğinizi keşfedin. Bu eğlenceli quiz ile hangi kahve türünün size en uygun olduğunu öğrenin!',
    'hasTimeLimit': true,
    'expiresAt': DateTime.now().add(const Duration(days: 7)),
    'questions': [
      {
        'questionText': 'Sabah kalktığında ilk olarak ne yaparsın?',
        'options': [
          'Hemen kahve hazırlarım',
          'Önce duş alırım',
          'Sosyal medyaya bakarım',
          'Biraz daha yatarım',
        ],
      },
      {
        'questionText': 'Hangi ortamda çalışmayı tercih edersin?',
        'options': [
          'Sessiz bir kütüphanede',
          'Enerjik bir kafede',
          'Evde rahat ortamda',
          'Açık havada',
        ],
      },
      {
        'questionText': 'Arkadaşlarınla buluşurken nerede buluşursun?',
        'options': [
          'Sakin bir kafede',
          'Popüler bir restoranda',
          'Evde',
          'Dışarıda doğayla iç içe',
        ],
      },
      {
        'questionText': 'Stresliyken ne yaparsın?',
        'options': [
          'Kahve içerim',
          'Müzik dinlerim',
          'Yürüyüşe çıkarım',
          'Kitap okurum',
        ],
      },
    ],
    'results': [
      {
        'title': 'Espresso Kişiliği',
        'description':
            'Sen güçlü, kararlı ve enerjik bir kişisin. Hayatın her anında maksimum verimlilik arıyorsun.',
        'icon': 'local_fire_department',
      },
      {
        'title': 'Cappuccino Kişiliği',
        'description':
            'Sen dengeli, sosyal ve uyumlu bir kişisin. Hem çalışmayı hem de eğlenmeyi seversin.',
        'icon': 'favorite',
      },
      {
        'title': 'Latte Kişiliği',
        'description':
            'Sen yumuşak, sakin ve yaratıcı bir kişisin. Güzelliği ve rahatlığı hayatının merkezine koyarsın.',
        'icon': 'palette',
      },
      {
        'title': 'Americano Kişiliği',
        'description':
            'Sen sade, pratik ve güvenilir bir kişisin. Karmaşıklıktan kaçınır, doğallığı tercih edersin.',
        'icon': 'star',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final questions = _mockQuizData['questions'] as List;
    final results = _mockQuizData['results'] as List;

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
                  title: _mockQuizData['title'] as String,
                  description: _mockQuizData['description'] as String,
                  hasTimeLimit: _mockQuizData['hasTimeLimit'] as bool,
                  expiresAt: _mockQuizData['expiresAt'] as DateTime,
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
  }

  void _simulateQuiz(List<dynamic> results) {
    final random = DateTime.now().millisecondsSinceEpoch % results.length;
    final simulatedResult = results[random] as Map<String, dynamic>;

    QuizPreviewDialog.show(context, simulatedResult);
  }
}
