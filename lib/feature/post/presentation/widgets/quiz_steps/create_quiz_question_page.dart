import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_state.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_question_card.dart';

class CreateQuizQuestionScreen extends StatefulWidget {
  // final GlobalKey<FormState> formKey;
  const CreateQuizQuestionScreen({super.key});

  @override
  State<CreateQuizQuestionScreen> createState() =>
      _CreateQuizQuestionScreenState();
}

class _CreateQuizQuestionScreenState extends State<CreateQuizQuestionScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateQuizCubit, CreateQuizState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<CreateQuizCubit, CreateQuizState>(
            listener: (context, state) {
              // ✅ Validation error'ları form field'larda göster
              if (state.status == FormStatus.invalid) {
                // Form'u yeniden validate et ki error'lar görünsün
                formKey.currentState?.validate();
              }
            },
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.questions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: QuizQuestionCard(
                            question: state.questions[index],
                            questionNumber: index + 1,
                            onRemove: state.questions.length > 1
                                ? () => context
                                      .read<CreateQuizCubit>()
                                      .removeQuestion(index)
                                : null,
                            onQuestionChanged: (value) {
                              context
                                  .read<CreateQuizCubit>()
                                  .updateQuestionText(index, value);
                            },
                            onOptionsChanged: () {
                              setState(() {}); // UI'ı yenile
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<CreateQuizCubit>().addQuestion(),
                    icon: const Icon(Icons.add),
                    label: const Text('Soru Ekle'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
