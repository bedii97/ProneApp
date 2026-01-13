import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/data/supabase_post_repo.dart';
import 'package:prone/feature/post/presentation/cubits/quiz/quiz_detail_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final SupabasePostRepo _quizRepository;
  final String _quizId;

  QuizCubit({required SupabasePostRepo quizRepository, required String quizId})
    : _quizRepository = quizRepository,
      _quizId = quizId,
      super(const QuizState()) {
    _loadQuiz();
  }

  // 1. Quizi Yükle
  Future<void> _loadQuiz() async {
    emit(state.copyWith(status: QuizStatus.loading));
    try {
      final quiz = await _quizRepository.getQuizById(_quizId);
      emit(state.copyWith(status: QuizStatus.loaded, quiz: quiz));
    } catch (e) {
      emit(
        state.copyWith(status: QuizStatus.error, errorMessage: e.toString()),
      );
    }
  }

  // 2. Seçenek Seç
  void selectOption(String questionId, String optionId) {
    final newAnswers = Map<String, String>.from(state.answers);
    newAnswers[questionId] = optionId;

    emit(state.copyWith(answers: newAnswers));
  }

  // 3. İlerle veya Bitir
  Future<void> nextOrSubmit() async {
    if (state.isLastQuestion) {
      await _submitQuiz();
    } else {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  // 4. Backend'e Gönder (Edge Function)
  Future<void> _submitQuiz() async {
    if (state.quiz == null) return;

    emit(state.copyWith(status: QuizStatus.submitting));

    try {
      // Repository üzerinden Edge Function'a gidiyoruz
      final result = await _quizRepository.submitQuiz(
        quizId: state.quiz!.id!,
        answers: state.answers,
      );
      emit(state.copyWith(status: QuizStatus.completed, result: result));
    } catch (e) {
      emit(
        state.copyWith(
          status: QuizStatus.error,
          errorMessage: "Sonuç hesaplanırken hata oluştu: $e",
        ),
      );
    }
  }
}
