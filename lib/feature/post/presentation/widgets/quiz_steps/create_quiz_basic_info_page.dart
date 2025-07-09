import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/core/utils/quiz_validator.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_state.dart';

class CreateQuizBasicInfoScreen extends StatefulWidget {
  const CreateQuizBasicInfoScreen({super.key});

  @override
  State<CreateQuizBasicInfoScreen> createState() =>
      _CreateQuizBasicInfoScreenState();
}

class _CreateQuizBasicInfoScreenState extends State<CreateQuizBasicInfoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final currentState = context.read<CreateQuizCubit>().state;
    _titleController.text = currentState.title;
    _descriptionController.text = currentState.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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

    if (pickedDate != null) {
      if (!mounted) return;

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 23, minute: 59),
      );

      if (pickedTime != null) {
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

  setHasTimeLimit(bool value) {
    context.read<CreateQuizCubit>().hasTimeLimitChanged(value);
    if (!value) {
      context.read<CreateQuizCubit>().expiresAtChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTimeLimit = context.watch<CreateQuizCubit>().state.hasTimeLimit;
    final expiresAt = context.watch<CreateQuizCubit>().state.expiresAt;
    return Column(
      children: [
        // Form Content
        Expanded(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quiz Title
                    const Text(
                      'Quiz Başlığı',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
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
                    const SizedBox(height: 24),

                    // Quiz Description
                    const Text(
                      'Quiz Açıklaması (İsteğe bağlı)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
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
                        context.read<CreateQuizCubit>().descriptionChanged(
                          value,
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Time Limit Settings
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Süre Ayarları',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Time Limit Toggle
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Süre sınırı ekle'),
                              subtitle: Text(
                                hasTimeLimit
                                    ? 'Quiz belirli bir tarihte sona erecek'
                                    : 'Quiz süresiz olacak',
                              ),
                              value: hasTimeLimit,
                              onChanged: setHasTimeLimit,
                            ),

                            // Date Time Picker
                            if (hasTimeLimit) ...[
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Bitiş Tarihi ve Saati',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: _selectExpireDate,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[400]!,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              expiresAt != null
                                                  ? '${expiresAt.day}/${expiresAt.month}/${expiresAt.year} - ${expiresAt.hour.toString().padLeft(2, '0')}:${expiresAt.minute.toString().padLeft(2, '0')}'
                                                  : 'Tarih ve saat seçin',
                                              style: TextStyle(
                                                color: expiresAt != null
                                                    ? Colors.black
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Sonraki adımlarda sorularınızı, seçeneklerinizi ve olası sonuçlarınızı belirleyeceksiniz.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
