import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_model.dart';
import 'package:prone/feature/home/presentation/widgets/post_cards/components/post_header.dart';
import 'package:prone/feature/home/presentation/widgets/post_cards/components/post_content.dart';

class QuizCard extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback? onQuizStart;
  const QuizCard({super.key, required this.quiz, this.onQuizStart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (quiz.userCompleted) {
      return _buildQuizResultCard(context, theme);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - User info ve zaman
          Padding(
            padding: const EdgeInsets.all(16),
            child: PostHeader(post: quiz),
          ),

          // Content - Title ve description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PostContent(post: quiz),
          ),

          const SizedBox(height: 16),

          // Quiz Visual Section - Ana quiz alanı
          _buildQuizVisual(context, theme),

          const SizedBox(height: 16),

          // Quiz Info Strip
          // _buildQuizInfoStrip(context, theme),
        ],
      ),
    );
  }

  Widget _buildQuizResultCard(BuildContext context, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - User info ve zaman
          Padding(
            padding: const EdgeInsets.all(16),
            child: PostHeader(post: quiz),
          ),

          // Content - Title ve description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PostContent(post: quiz),
          ),

          const SizedBox(height: 16),

          // Quiz Visual Section - Ana quiz alanı
          _buildQuizVisual(context, theme),

          // Quiz Info Strip
          _buildQuizInfoStrip(context, theme),
        ],
      ),
    );
  }

  Widget _buildQuizVisual(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor.withValues(alpha: 0.8),
            theme.primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _QuizPatternPainter(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Left side - Quiz info
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.psychology, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'QUIZ',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${quiz.questions.length} Soru',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (quiz.completionCount > 0)
                        Text(
                          '${quiz.completionCount} kişi katıldı',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                    ],
                  ),
                ),

                // Right side - Action button
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_buildFloatingActionButton(context, theme)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, ThemeData theme) {
    bool userParticipated = quiz.userCompleted;

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (userParticipated) {
              _showQuizResults(context);
            } else {
              _startQuiz(context);
            }
          },
          borderRadius: BorderRadius.circular(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                userParticipated ? Icons.visibility : Icons.play_arrow,
                color: theme.primaryColor,
                size: 28,
              ),
              const SizedBox(height: 2),
              Text(
                userParticipated ? 'SONUÇ' : 'BAŞLA',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizInfoStrip(BuildContext context, ThemeData theme) {
    if (quiz.questions.isEmpty) return const SizedBox.shrink();
    if (!quiz.userCompleted) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Quiz Sonucunuz: "${quiz.completion?.quizResult.title}"',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 12, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  'Tamamlandı',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startQuiz(BuildContext context) {
    if (onQuizStart != null) {
      onQuizStart!();
    }
  }

  void _showQuizResults(BuildContext context) {
    print('Quiz sonuçları gösteriliyor: ${quiz.id}');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Quiz Sonuçları'),
          content: Text(
            'Quiz Sonucunuz: "${quiz.completion?.quizResult.title}"',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Kapat'),
            ),
          ],
        );
      },
    );
    // context.push('/quiz/${quiz.id}/results');
  }
}

// Custom painter for background pattern
class _QuizPatternPainter extends CustomPainter {
  final Color color;

  _QuizPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw question mark pattern
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 6; j++) {
        final x = (size.width / 6) * j + (i % 2) * (size.width / 12);
        final y = (size.height / 4) * i;

        // Draw small circles as pattern
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
