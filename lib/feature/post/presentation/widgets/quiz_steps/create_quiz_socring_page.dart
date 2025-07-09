import 'package:flutter/material.dart';

class CreateQuizScoringPage extends StatefulWidget {
  const CreateQuizScoringPage({super.key});

  @override
  State<CreateQuizScoringPage> createState() => _CreateQuizScoringPageState();
}

class _CreateQuizScoringPageState extends State<CreateQuizScoringPage> {
  // Mock data for UI testing
  final List<Map<String, dynamic>> _mockQuestions = [
    {
      'id': 'q1',
      'question': 'Hangi aktiviteyi daha çok seversiniz?',
      'options': [
        {'id': 'opt1', 'text': 'Kitap okuma'},
        {'id': 'opt2', 'text': 'Resim yapma'},
        {'id': 'opt3', 'text': 'Spor yapma'},
        {'id': 'opt4', 'text': 'Müzik dinleme'},
      ],
    },
    {
      'id': 'q2',
      'question': 'Sosyal ortamlarda nasıl davranırsınız?',
      'options': [
        {'id': 'opt1', 'text': 'Aktif olarak sohbete katılırım'},
        {'id': 'opt2', 'text': 'Dinlemeyi tercih ederim'},
        {'id': 'opt3', 'text': 'Liderlik yaparım'},
        {'id': 'opt4', 'text': 'Sessizce gözlem yaparım'},
      ],
    },
  ];

  final List<Map<String, dynamic>> _mockResults = [
    {'id': 'result1', 'title': 'Lider Tip', 'color': Colors.amber},
    {'id': 'result2', 'title': 'Yaratıcı Tip', 'color': Colors.purple},
    {'id': 'result3', 'title': 'Analist Tip', 'color': Colors.blue},
    {'id': 'result4', 'title': 'Sosyal Tip', 'color': Colors.green},
  ];

  // Mock scoring data: questionId -> optionId -> resultId -> points
  final Map<String, Map<String, Map<String, int>>> _mockScoring = {};

  void _updateScoring(
    String questionId,
    String optionId,
    String resultId,
    int points,
  ) {
    setState(() {
      _mockScoring[questionId] ??= {};
      _mockScoring[questionId]![optionId] ??= {};
      _mockScoring[questionId]![optionId]![resultId] = points;
    });

    // TODO: context.read<CreateQuizCubit>().updateScoring(questionId, optionId, resultId, points);
  }

  void _autoFillScoring() {
    // Auto-fill example logic
    setState(() {
      for (var question in _mockQuestions) {
        final questionId = question['id'];
        _mockScoring[questionId] = {};

        for (int i = 0; i < question['options'].length; i++) {
          final optionId = question['options'][i]['id'];
          _mockScoring[questionId]![optionId] = {};

          // Simple auto-fill: give random points
          for (int j = 0; j < _mockResults.length; j++) {
            final resultId = _mockResults[j]['id'];
            final points = (i == j)
                ? 5
                : (i == j + 1 || i == j - 1)
                ? 2
                : 0;
            _mockScoring[questionId]![optionId]![resultId] = points;
          }
        }
      }
    });

    // TODO: context.read<CreateQuizCubit>().autoFillScoring();
  }

  void _clearAllScoring() {
    setState(() {
      _mockScoring.clear();
    });

    // TODO: context.read<CreateQuizCubit>().clearAllScoring();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with BlocBuilder<CreateQuizCubit, CreateQuizState>
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(),
                const SizedBox(height: 24),

                // Balance Overview
                _buildBalanceOverview(),
                const SizedBox(height: 24),

                // Questions List
                ..._mockQuestions.map(
                  (question) => _buildQuestionCard(question),
                ),

                const SizedBox(height: 32),

                // Requirements Check
                _buildRequirementsCheck(),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildBalanceOverview() {
    final totalPoints = _calculateTotalPoints();

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
            children: _mockResults.map((result) {
              final resultPoints = _calculateResultPoints(result['id']);
              final percentage = totalPoints > 0
                  ? (resultPoints / totalPoints) * 100
                  : 0;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (result['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: result['color']),
                  ),
                  child: Column(
                    children: [
                      Text(
                        result['title'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
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
                          color: result['color'],
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

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    final questionId = question['id'];
    final questionText = question['question'];
    final options = question['options'] as List;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                questionText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Options List
            ...options.map((option) => _buildOptionScoring(questionId, option)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionScoring(String questionId, Map<String, dynamic> option) {
    final optionId = option['id'];
    final optionText = option['text'];

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
            optionText,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          // Results Scoring
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _mockResults.map((result) {
              final resultId = result['id'];
              final currentPoints =
                  _mockScoring[questionId]?[optionId]?[resultId] ?? 0;

              return _buildResultScoring(
                questionId,
                optionId,
                resultId,
                result['title'],
                result['color'],
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
      // width: 120,
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

          // Point Buttons
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
                      ? Icon(Icons.check, size: 10, color: Colors.white)
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

  Widget _buildRequirementsCheck() {
    final isComplete = _validateScoring();
    final totalQuestions = _mockQuestions.length;
    final completedQuestions = _getCompletedQuestionsCount();

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
            _allResultsHavePoints(),
          ),
          _buildRequirementItem('Puan dağılımı dengeli', _isBalanced()),
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

  // Helper methods for validation
  bool _validateScoring() {
    return _getCompletedQuestionsCount() == _mockQuestions.length &&
        _allResultsHavePoints() &&
        _isBalanced();
  }

  int _getCompletedQuestionsCount() {
    int count = 0;
    for (var question in _mockQuestions) {
      final questionId = question['id'];
      if (_mockScoring[questionId] != null) {
        bool questionComplete = true;
        for (var option in question['options']) {
          final optionId = option['id'];
          if (_mockScoring[questionId]![optionId] == null ||
              _mockScoring[questionId]![optionId]!.isEmpty) {
            questionComplete = false;
            break;
          }
        }
        if (questionComplete) count++;
      }
    }
    return count;
  }

  bool _allResultsHavePoints() {
    for (var result in _mockResults) {
      final resultId = result['id'];
      if (_calculateResultPoints(resultId) == 0) {
        return false;
      }
    }
    return true;
  }

  bool _isBalanced() {
    final totalPoints = _calculateTotalPoints();
    if (totalPoints == 0) return false;

    final averagePoints = totalPoints / _mockResults.length;
    for (var result in _mockResults) {
      final resultPoints = _calculateResultPoints(result['id']);
      final difference = (resultPoints - averagePoints).abs();
      if (difference > averagePoints * 0.5) {
        // 50% tolerance
        return false;
      }
    }
    return true;
  }

  int _calculateTotalPoints() {
    int total = 0;
    _mockScoring.forEach((questionId, questionScoring) {
      questionScoring.forEach((optionId, optionScoring) {
        optionScoring.forEach((resultId, points) {
          total += points;
        });
      });
    });
    return total;
  }

  int _calculateResultPoints(String resultId) {
    int total = 0;
    _mockScoring.forEach((questionId, questionScoring) {
      questionScoring.forEach((optionId, optionScoring) {
        total += optionScoring[resultId] ?? 0;
      });
    });
    return total;
  }
}
