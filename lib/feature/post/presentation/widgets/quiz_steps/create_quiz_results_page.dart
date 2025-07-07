import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/quiz_result_model.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_result_card.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_results_add_button.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_results_empty_state.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_results_header.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_results_requirements.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/quiz_results_templates.dart';

class CreateQuizResultsPage extends StatefulWidget {
  const CreateQuizResultsPage({super.key});

  @override
  State<CreateQuizResultsPage> createState() => _CreateQuizResultsPageState();
}

class _CreateQuizResultsPageState extends State<CreateQuizResultsPage> {
  //Predefined icons
  final List<String> _availableIcons = [
    'emoji_events',
    'palette',
    'analytics',
    'groups',
    'psychology',
    'favorite',
    'star',
    'local_fire_department',
    'lightbulb',
    'bolt',
    'nature_people',
    'celebration',
  ];

  void _addResult() {
    //Create a new result with random icon
    Random rnd = Random();
    final result = QuizResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      description: '',
      icon: _availableIcons[rnd.nextInt(_availableIcons.length)],
    );

    context.read<CreateQuizCubit>().addResult(result);
  }

  void _addResultFromTemplate(Map<String, dynamic> template) {
    context.read<CreateQuizCubit>().addResultFromTemplate(template);
  }

  void _removeResult(int index) {
    context.read<CreateQuizCubit>().removeResult(index);
  }

  void _duplicateResult(int index) {
    context.read<CreateQuizCubit>().duplicateResult(index);
  }

  void _updateResult(int index, Map<String, dynamic> updatedData) {
    final cubit = context.read<CreateQuizCubit>();
    if (index >= 0 && index < cubit.state.results.length) {
      final current = cubit.state.results[index];
      final updated = current.copyWith(
        title: updatedData['title'] ?? current.title,
        description: updatedData['description'] ?? current.description,
        icon: updatedData['icon'] ?? current.icon,
      );
      cubit.updateResult(index, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = context.watch<CreateQuizCubit>().state.results;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                QuizResultsHeader(resultCount: results.length),
                const SizedBox(height: 24),

                // Quick Templates (if no results yet)
                if (results.isEmpty)
                  QuizResultsTemplates(
                    onTemplateSelected: _addResultFromTemplate,
                  ),

                // Results List
                if (results.isEmpty)
                  QuizResultsEmptyState(onAddResult: _addResult)
                else
                  ...results.asMap().entries.map((entry) {
                    return QuizResultCard(
                      result: entry.value,
                      index: entry.key,
                      onUpdate: _updateResult,
                      onDuplicate: _duplicateResult,
                      onDelete: _removeResult,
                    );
                  }),

                const SizedBox(height: 16),

                // Add Result Button
                QuizResultsAddButton(onPressed: _addResult),

                const SizedBox(height: 32),

                // Requirements Info
                QuizResultsRequirements(results: results),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
