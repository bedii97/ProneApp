import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_question_card.dart';

class CreateQuizQuestionScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const CreateQuizQuestionScreen({super.key, required this.formKey});

  @override
  State<CreateQuizQuestionScreen> createState() =>
      _CreateQuizQuestionScreenState();
}

class _CreateQuizQuestionScreenState extends State<CreateQuizQuestionScreen> {
  List<QuizQuestion> questions = [QuizQuestion()];

  void _addQuestion() {
    setState(() {
      questions.add(QuizQuestion());
    });
  }

  void _removeQuestion(int index) {
    if (questions.length > 1) {
      setState(() {
        questions.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: QuizQuestionCard(
                    question: questions[index],
                    questionNumber: index + 1,
                    onRemove: questions.length > 1
                        ? () => _removeQuestion(index)
                        : null,
                    onQuestionChanged: (value) {
                      setState(() {
                        questions[index].questionText = value;
                      });
                    },
                    onOptionsChanged: () {
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: _addQuestion,
            icon: const Icon(Icons.add),
            label: const Text('Soru Ekle'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}
