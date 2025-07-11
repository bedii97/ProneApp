import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/quiz_question_model.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_state.dart';

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
                      return _buildQuestionCard(entry.value, entry.key, state);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Puan Sistemi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Her sorunun seçeneklerini sonuçlarla eşleştirin. Seçenekler farklı sonuçlara 0-5 puan arasında değer verebilir.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hızlı İşlemler',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _autoFillScoring,
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Otomatik Doldur'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    foregroundColor: Colors.blue[700],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearAllScoring,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Tümünü Temizle'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceOverview(CreateQuizState state) {
    final totalPoints = _calculateTotalPoints(state);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Puan Dengesi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: state.results.map((result) {
              final resultPoints = state.getTotalPointsForResult(result.id);
              final percentage = totalPoints > 0
                  ? (resultPoints / totalPoints) * 100
                  : 0;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _hexToColor(
                      result.colorValue,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _hexToColor(result.colorValue)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        result.title.isEmpty
                            ? 'Sonuç ${state.results.indexOf(result) + 1}'
                            : result.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$resultPoints puan',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '%${percentage.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _hexToColor(result.colorValue),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    QuizQuestionModel question,
    int questionIndex,
    CreateQuizState state,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                question.questionText.isEmpty
                    ? 'Soru ${questionIndex + 1}'
                    : question.questionText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ),
            const SizedBox(height: 16),

            ...question.options.asMap().entries.map((entry) {
              final optionIndex = entry.key;
              final optionText = entry.value;
              final optionId = 'option_${questionIndex}_$optionIndex';

              return _buildOptionScoring(
                question.id,
                optionId,
                optionText,
                optionIndex,
                state,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionScoring(
    String questionId,
    String optionId,
    String optionText,
    int optionIndex,
    CreateQuizState state,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            optionText.isEmpty
                ? 'Seçenek ${String.fromCharCode(65 + optionIndex)}'
                : optionText,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.results.map((result) {
              final scoring = state.getScoringForOption(questionId, optionId);
              final currentPoints = scoring?.getPointsForResult(result.id) ?? 0;

              return _buildResultScoring(
                questionId,
                optionId,
                result.id,
                result.title.isEmpty
                    ? 'Sonuç ${state.results.indexOf(result) + 1}'
                    : result.title,
                _hexToColor(result.colorValue),
                currentPoints,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScoring(
    String questionId,
    String optionId,
    String resultId,
    String resultTitle,
    Color resultColor,
    int currentPoints,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: resultColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: resultColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            resultTitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: resultColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final points = index;
              final isSelected = currentPoints == points;

              return GestureDetector(
                onTap: () =>
                    _updateScoring(questionId, optionId, resultId, points),
                child: Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? resultColor : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 10, color: Colors.white)
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          Text(
            '$currentPoints puan',
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
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

  // Helper methods
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
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
