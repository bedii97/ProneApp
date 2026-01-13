import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/core/utils/quiz_validator.dart';
import 'package:prone/feature/post/presentation/cubits/quiz/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/quiz/create_quiz_state.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/components.dart';

class CreateQuizBasicInfoPage extends StatefulWidget {
  const CreateQuizBasicInfoPage({super.key});

  @override
  State<CreateQuizBasicInfoPage> createState() =>
      _CreateQuizBasicInfoPageState();
}

class _CreateQuizBasicInfoPageState extends State<CreateQuizBasicInfoPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  Future<void> _selectExpireDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 23, minute: 59),
      );

      if (pickedTime != null && mounted) {
        context.read<CreateQuizCubit>().expiresAtChanged(
          DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ),
        );
      }
    }
  }

  void _setHasTimeLimit(bool value) {
    context.read<CreateQuizCubit>().hasTimeLimitChanged(value);
    if (!value) {
      context.read<CreateQuizCubit>().expiresAtChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateQuizCubit, CreateQuizState>(
      listener: (context, state) {
        if (state.status == FormStatus.invalid) {
          formKey.currentState?.validate();
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleField(state),
                      const SizedBox(height: 24),

                      _buildDescriptionField(state),
                      const SizedBox(height: 24),

                      QuizTimeLimitSettings(
                        hasTimeLimit: state.hasTimeLimit,
                        expiresAt: state.expiresAt,
                        onTimeLimitChanged: _setHasTimeLimit,
                        onDateTimeSelect: _selectExpireDate,
                      ),

                      const SizedBox(height: 32),

                      _buildInfoCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleField(CreateQuizState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz Başlığı',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: state.title,
          decoration: const InputDecoration(
            hintText: 'Hangi Harry Potter karakterisin?',
            border: OutlineInputBorder(),
            counterText: '',
          ),
          maxLength: 100,
          maxLines: 2,
          validator: QuizValidator.validateQuizTitle,
          onChanged: (value) {
            context.read<CreateQuizCubit>().titleChanged(value);
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField(CreateQuizState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quiz Açıklaması (İsteğe bağlı)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: state.description,
          decoration: const InputDecoration(
            hintText:
                'Bu quiz kişiliğinizi analiz ederek size en uygun karakteri bulur...',
            border: OutlineInputBorder(),
            counterText: '',
          ),
          maxLength: 500,
          maxLines: 4,
          validator: QuizValidator.validateQuizDescription,
          onChanged: (value) {
            context.read<CreateQuizCubit>().descriptionChanged(value);
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sonraki adımlarda sorularınızı, seçeneklerinizi ve olası sonuçlarınızı belirleyeceksiniz.',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
