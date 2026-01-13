import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/presentation/cubits/quiz/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/quiz/create_quiz_state.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/quiz_scoring/balance_overview.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/quiz_scoring/header.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/quiz_scoring/question_card.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/quiz_scoring/quick_actions.dart';

class CreateQuizScoringPage extends StatefulWidget {
  const CreateQuizScoringPage({super.key});

  @override
  State<CreateQuizScoringPage> createState() => _CreateQuizScoringPageState();
}

class _CreateQuizScoringPageState extends State<CreateQuizScoringPage> {
  void _updateScoring(
    String questionId,
    String optionId,
    String resultId,
    int points,
  ) {
    context.read<CreateQuizCubit>().updateScoring(
      questionId,
      optionId,
      resultId,
      points,
    );
  }

  void _autoFillScoring() {
    context.read<CreateQuizCubit>().autoFillScoring();
  }

  void _clearAllScoring() {
    context.read<CreateQuizCubit>().clearAllScoring();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateQuizCubit, CreateQuizState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildBalanceOverview(state),
                    const SizedBox(height: 24),

                    // Questions List with real data
                    ...state.questions.asMap().entries.map((entry) {
                      // return QuestionCard(entry.value, entry.key, state);
                      return QuestionCard(
                        question: entry.value,
                        questionIndex: entry.key,
                        state: state,
                        updateScoring: _updateScoring,
                      );
                    }),

                    const SizedBox(height: 32),
                    _buildRequirementsCheck(state),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Header();
  }

  Widget _buildQuickActions() {
    return QuickActions(
      onAutoFill: _autoFillScoring,
      onClearAll: _clearAllScoring,
    );
  }

  Widget _buildBalanceOverview(CreateQuizState state) {
    return BalanceOverview(state: state);
  }

  Widget _buildRequirementsCheck(CreateQuizState state) {
    final isComplete = _validateScoring(state);
    final totalQuestions = state.questions.length;
    final completedQuestions = _getCompletedQuestionsCount(state);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isComplete ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isComplete ? Icons.check_circle : Icons.info_outline,
                color: isComplete ? Colors.green[600] : Colors.orange[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isComplete ? 'Tamamlandı!' : 'Eksik gereksinimler',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isComplete ? Colors.green[700] : Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildRequirementItem(
            'Tüm sorular puanlandırılmış',
            completedQuestions == totalQuestions,
          ),
          _buildRequirementItem(
            'Her sonuç en az bir puan almış',
            _allResultsHavePoints(state),
          ),
          _buildRequirementItem('Puan dağılımı dengeli', _isBalanced(state)),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check : Icons.radio_button_unchecked,
            size: 16,
            color: isCompleted ? Colors.green[600] : Colors.grey[500],
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isCompleted ? Colors.green[700] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  bool _validateScoring(CreateQuizState state) {
    return _getCompletedQuestionsCount(state) == state.questions.length &&
        _allResultsHavePoints(state) &&
        _isBalanced(state);
  }

  int _getCompletedQuestionsCount(CreateQuizState state) {
    int count = 0;
    for (int i = 0; i < state.questions.length; i++) {
      final question = state.questions[i];
      bool questionComplete = true;

      for (int j = 0; j < question.options.length; j++) {
        final optionId = 'option_${i}_$j';
        final scoring = state.getScoringForOption(question.id, optionId);

        if (scoring == null || scoring.resultPoints.isEmpty) {
          questionComplete = false;
          break;
        }
      }

      if (questionComplete) count++;
    }
    return count;
  }

  bool _allResultsHavePoints(CreateQuizState state) {
    for (var result in state.results) {
      if (state.getTotalPointsForResult(result.id) == 0) {
        return false;
      }
    }
    return true;
  }

  bool _isBalanced(CreateQuizState state) {
    final totalPoints = _calculateTotalPoints(state);
    if (totalPoints == 0) return false;

    final averagePoints = totalPoints / state.results.length;
    for (var result in state.results) {
      final resultPoints = state.getTotalPointsForResult(result.id);
      final difference = (resultPoints - averagePoints).abs();
      if (difference > averagePoints * 0.5) {
        return false;
      }
    }
    return true;
  }

  int _calculateTotalPoints(CreateQuizState state) {
    return state.scoring.fold<int>(0, (total, scoring) {
      return total +
          scoring.resultPoints.values.fold<int>(
            0,
            (sum, points) => sum + points,
          );
    });
  }
}
