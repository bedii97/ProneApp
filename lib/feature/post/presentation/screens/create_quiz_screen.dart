import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prone/feature/post/data/supabase_post_repo.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_state.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/quiz_steps.dart';

class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateQuizCubit(context.read<SupabasePostRepo>()),
      child: const CreateQuizView(),
    );
  }
}

class CreateQuizView extends StatefulWidget {
  const CreateQuizView({super.key});

  @override
  State<CreateQuizView> createState() => _CreateQuizViewState();
}

class _CreateQuizViewState extends State<CreateQuizView> {
  final PageController _pageController = PageController();

  final List<String> _stepTitles = [
    'Temel Bilgiler',
    'Sorular',
    'Sonuçlar',
    'Puan Sistemi',
    'Önizleme',
  ];

  late final List<Widget> stepWidgets;

  @override
  void initState() {
    super.initState();
    stepWidgets = [
      CreateQuizBasicInfoPage(),
      CreateQuizQuestionPage(),
      CreateQuizResultsPage(),
      CreateQuizScoringPage(),
      CreateQuizPreviewPage(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    final cubit = context.read<CreateQuizCubit>();

    // ✅ Sadece cubit'i çağır - validation cubit'te
    cubit.nextStep();

    // ✅ Validation error varsa UI'da göster
    if (cubit.state.status == FormStatus.invalid) {
      _showValidationErrors(cubit.state.validationErrors);
      return;
    }

    // ✅ Success ise sayfayı değiştir
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showValidationErrors(Map<String, String> errors) {
    if (errors.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lütfen aşağıdaki hataları düzeltin:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...errors.values.map(
              (error) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $error'),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        // action: SnackBarAction(
        //   label: 'Tamam',
        //   onPressed: () {
        //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //   },
        // ),
      ),
    );
  }

  void _publishQuiz() {
    final cubit = context.read<CreateQuizCubit>();
    cubit.publishQuiz();
  }

  void _previousStep() {
    final cubit = context.read<CreateQuizCubit>();
    if (cubit.step > 0) {
      cubit.previousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Oluşturmayı Bırak'),
          content: const Text(
            'Çıkarsanız tüm verileriniz kaybolacak. Emin misiniz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Çık'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Quiz oluşturma süreci devam ediyorsa uyar
        final state = context.read<CreateQuizCubit>().state;
        if (state.status == FormStatus.submissionInProgress) {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Quiz Oluşturuluyor'),
              content: const Text(
                'Quiz oluşturma işlemi devam ediyor. Çıkmak istediğinizden emin misiniz?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Çık'),
                ),
              ],
            ),
          );
          if (shouldExit == true && mounted) {
            context.pop();
          }
          return;
        }

        final shouldExit = await _showExitConfirmationDialog();
        if (shouldExit && mounted) {
          context.pop();
        }
      },
      child: BlocListener<CreateQuizCubit, CreateQuizState>(
        listener: (context, state) {
          if (state.status == FormStatus.submissionSuccess) {
            // Ana sayfaya yönlendir ve tüm quiz oluşturma sayfalarını temizle
            context.go('/');

            // Success mesajı göster
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Quiz başarıyla oluşturuldu! 🎉'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state.status == FormStatus.submissionFailure) {
            // Hata durumunda mesaj göster (sayfa kapanmasın)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Hata: ${state.errorMessage ?? "Bilinmeyen hata"}',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Tekrar Dene',
                  textColor: Colors.white,
                  onPressed: () {
                    // Tekrar deneme için publishQuiz'i çağır
                    _publishQuiz();
                  },
                ),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Quiz Oluştur'),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                // Loading durumu kontrolü
                final state = context.read<CreateQuizCubit>().state;
                if (state.status == FormStatus.submissionInProgress) {
                  final shouldExit = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Quiz Oluşturuluyor'),
                      content: const Text(
                        'Quiz oluşturma işlemi devam ediyor. Çıkmak istediğinizden emin misiniz?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('İptal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Çık'),
                        ),
                      ],
                    ),
                  );
                  if (shouldExit == true && mounted) {
                    context.pop();
                  }
                  return;
                }

                final shouldExit = await _showExitConfirmationDialog();
                if (shouldExit && mounted) {
                  context.pop();
                }
              },
            ),
          ),
          body: Column(
            children: [
              // Progress Indicator
              BlocBuilder<CreateQuizCubit, CreateQuizState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adım ${state.step + 1}/5: ${_stepTitles[state.step]}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: (state.step + 1) / 5),
                      ],
                    ),
                  );
                },
              ),

              // PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: stepWidgets,
                ),
              ),

              // Bottom Navigation
              BlocBuilder<CreateQuizCubit, CreateQuizState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Row(
                      children: [
                        if (state.step > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  state.status ==
                                      FormStatus.submissionInProgress
                                  ? null
                                  : _previousStep,
                              child: const Text('Geri'),
                            ),
                          ),
                        if (state.step > 0) const SizedBox(width: 16),
                        if (state.step == 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  state.status ==
                                      FormStatus.submissionInProgress
                                  ? null
                                  : () async {
                                      final shouldExit =
                                          await _showExitConfirmationDialog();
                                      if (shouldExit && mounted) {
                                        context.pop();
                                      }
                                    },
                              child: const Text('İptal'),
                            ),
                          ),
                        if (state.step == 0) const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                state.status == FormStatus.submissionInProgress
                                ? null
                                : (state.step == 4 ? _publishQuiz : _nextStep),
                            child:
                                state.status == FormStatus.submissionInProgress
                                ? const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Yayınlanıyor...'),
                                    ],
                                  )
                                : Text(state.step == 4 ? 'Yayınla' : 'İleri'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
