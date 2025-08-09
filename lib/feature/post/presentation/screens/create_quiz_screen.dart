import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_state.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/quiz_steps.dart';

class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateQuizCubit(),
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
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        // behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Tamam',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _publishQuiz() {
    print('Quiz yayınlanıyor...');
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
              style: TextButton.styleFrom(foregroundColor: Colors.red),
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
      // PopScope ve AppBar kısımları Cubit'in state'ine bağlı olmadığı için burada kalabilir.
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await _showExitConfirmationDialog();
        if (shouldExit && mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Oluştur'),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldExit = await _showExitConfirmationDialog();
              if (shouldExit && mounted) {
                context.pop();
              }
            },
          ),
        ),
        body: Column(
          children: [
            // Sadece Progress Indicator kısmı BlocBuilder ile sarıldı.
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
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (state.step + 1) / 5,
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                );
              },
            ),

            // PageView kısmı Cubit state'ine bağlı değil, direkt kullanılıyor.
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: stepWidgets,
              ),
            ),

            // Sadece Bottom Navigation kısmı BlocBuilder ile sarıldı.
            BlocBuilder<CreateQuizCubit, CreateQuizState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(50),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (state.step > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousStep,
                            child: const Text('Geri'),
                          ),
                        ),
                      if (state.step > 0) const SizedBox(width: 16),
                      if (state.step == 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
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
                          onPressed: state.step == 4 ? _publishQuiz : _nextStep,
                          child: Text(state.step == 4 ? 'Yayınla' : 'İleri'),
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
    );
  }
}
