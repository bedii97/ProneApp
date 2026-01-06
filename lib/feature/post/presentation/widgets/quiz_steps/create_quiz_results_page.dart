/// Renk ekliyordum
/// Yeni sonuç ekle buttonunda renk okey oldu
/// Ama sonuç kartında renkler hala eski
/// Onu da halledeceğim
library;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_result_model.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/components/components.dart';

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

  final List<String> _availableColors = [
    '#FFCDD2', // Red
    '#C5CAE9', // Blue
    '#C8E6C9', // Green
    '#FFF9C4', // Yellow
    '#FFAB91', // Orange
    '#B39DDB', // Purple
    '#B2DFDB', // Teal
    '#FFECB3', // Light Yellow
  ];

  void _addResult({String? title, String? description}) {
    //Create a new result with random icon and color
    Random rnd = Random();
    final result = QuizResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title ?? '',
      description: description ?? '',
      icon: _availableIcons[rnd.nextInt(_availableIcons.length)],
      colorValue: _availableColors[rnd.nextInt(_availableColors.length)],
    );

    context.read<CreateQuizCubit>().addResult(result);
  }

  void _addResultFromTemplate(Map<String, dynamic> template) {
    // context.read<CreateQuizCubit>().addResultFromTemplate(template);
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
