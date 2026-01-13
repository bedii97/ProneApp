import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/data/supabase_post_repo.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_question_model.dart';
import 'package:prone/feature/post/presentation/cubits/quiz/quiz_detail_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/quiz/quiz_detail_state.dart';
// Result Screen importunu buraya ekle

class QuizDetailScreen extends StatefulWidget {
  final String quizId;
  const QuizDetailScreen({super.key, required this.quizId});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizCubit(
        quizId: widget.quizId,
        quizRepository: context
            .read<SupabasePostRepo>(), // Repository Injection
      ),
      child: BlocConsumer<QuizCubit, QuizState>(
        listener: (context, state) {
          // Hata Mesajı
          if (state.status == QuizStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Bir hata oluştu')),
            );
          }

          // Sayfa Geçişi (Animasyonlu)
          if (state.status == QuizStatus.loaded && _pageController.hasClients) {
            _pageController.animateToPage(
              state.currentIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }

          // Quiz Bitti -> Sonuç Ekranına Git
          if (state.status == QuizStatus.completed && state.result != null) {
            // ÖNEMLİ: Sonuç ekranına yönlendirme
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultScreen(result: state.result!)));
            print("Kazanılan Sonuç: ${state.result!.title}");
            showAboutDialog(
              context: context,
              children: [
                Text(
                  "Tebrikler! Quiz tamamlandı.\nSonuç: ${state.result!.title}",
                ),
              ],
            );
            // Navigator.pop(context); // Şimdilik sadece kapatıyor
          }
        },
        builder: (context, state) {
          final colorScheme = Theme.of(context).colorScheme;

          // 1. Loading Durumu
          if (state.status == QuizStatus.loading ||
              state.status == QuizStatus.initial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // 2. Quiz Yüklendi veya Gönderiliyor
          if (state.quiz == null) return Scaffold(appBar: AppBar());

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                state.quiz!.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(6.0),
                child: LinearProgressIndicator(
                  value:
                      (state.currentIndex + 1) / state.quiz!.questions.length,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: colorScheme.primary,
                  minHeight: 6,
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Soru Sayacı
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Soru ${state.currentIndex + 1}/${state.quiz!.questions.length}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),

                  // Sorular (PageView)
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.quiz!.questions.length,
                      itemBuilder: (context, index) {
                        final question = state.quiz!.questions[index];
                        return _buildQuestionCard(context, question, state);
                      },
                    ),
                  ),

                  // Buton (Sonraki Soru veya Bitir)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            (state.isCurrentQuestionAnswered &&
                                state.status != QuizStatus.submitting)
                            ? () => context.read<QuizCubit>().nextOrSubmit()
                            : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.status == QuizStatus.submitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                state.isLastQuestion
                                    ? "Bitir ve Sonucu Gör"
                                    : "Sonraki Soru",
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    QuizQuestionModel question,
    QuizState state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.questionText,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          // Seçenekler
          ...question.options.map((option) {
            // Seçili mi kontrolü artık ID üzerinden yapılıyor
            final isSelected = state.answers[question.id] == option.id;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _OptionTile(
                text: option.text,
                isSelected: isSelected,
                onTap: () => context.read<QuizCubit>().selectOption(
                  question.id,
                  option.id,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Şık tasarımı için özel widget (Resimdekine benzetildi)
class _OptionTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(
                  alpha: 0.1,
                ) // Seçili ise hafif renk
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Radio Button İkonu (Custom)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
