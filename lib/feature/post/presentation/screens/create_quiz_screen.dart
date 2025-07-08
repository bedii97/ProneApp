import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prone/feature/post/presentation/cubits/create_quiz_cubit.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/create_quiz_basic_info_page.dart';
import 'package:prone/feature/post/presentation/widgets/quiz_steps/create_quiz_question_page.dart';

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
  late final List<GlobalKey<FormState>> _formKeys;
  // int _currentStep = 0;

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
    _formKeys = List.generate(5, (index) => GlobalKey<FormState>());
    stepWidgets = [
      CreateQuizBasicInfoScreen(formKey: _formKeys[0]),
      CreateQuizQuestionScreen(formKey: _formKeys[1]),
      //Container(color: Colors.red),
      Container(color: Colors.green),
      Container(color: Colors.blue),
      Container(color: Colors.yellow),
    ];
  }

  void _nextStep() {
    final cubit = context.read<CreateQuizCubit>();

    // 1. Mevcut sayfanın formunu validate et
    final isFormValid = _formKeys[cubit.step].currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    // 2. Cubit seviyesinde validasyon yap
    if (!cubit.validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cubit.state.validationErrors.values.join('\n')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 3. Başarılıysa bir sonraki adıma geç
    if (cubit.step < 4) {
      cubit.nextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _publishQuiz() {
    print('Quiz yayınlanıyor...');
  }

  void _previousStep() {
    final cubit = context.read<CreateQuizCubit>();
    if (cubit.step > 0) {
      setState(() => cubit.previousStep());
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CreateQuizCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Oluştur'), elevation: 0),
      body: Column(
        children: [
          // Shared Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adım ${cubit.step + 1}/5: ${_stepTitles[cubit.step]}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (cubit.step + 1) / 5,
                  backgroundColor: Colors.grey[300],
                ),
              ],
            ),
          ),

          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: stepWidgets,
            ),
          ),

          // Shared Bottom Navigation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (cubit.step > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Geri'),
                    ),
                  ),
                if (cubit.step > 0) const SizedBox(width: 16),
                if (cubit.step == 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('İptal'),
                    ),
                  ),
                if (cubit.step == 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: cubit.step == 4 ? _publishQuiz : _nextStep,
                    child: Text(cubit.step == 4 ? 'Yayınla' : 'İleri'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
