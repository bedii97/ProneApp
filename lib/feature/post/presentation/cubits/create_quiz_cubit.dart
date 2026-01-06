import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/quiz/quiz_question_model.dart';
import 'package:prone/feature/post/domain/repos/post_repo.dart';

// Helpers
import 'helpers/helpers.dart';

// Mixins
import 'mixins/mixins.dart';

// State
import 'create_quiz_state.dart';

/// CreateQuizCubit - Quiz oluşturma sürecini yönetir
///
/// Bu cubit, quiz oluşturma sürecinin tüm adımlarını koordine eder:
/// - Temel bilgiler (başlık, açıklama, süre sınırı)
/// - Sorular ve seçenekler (QuestionManagementMixin)
/// - Sonuçlar (ResultsManagementMixin)
/// - Puanlama sistemi (ScoringManagementMixin)
/// - Form validation (CreateQuizValidator)
/// - Model building (CreateQuizModelBuilder)
class CreateQuizCubit extends Cubit<CreateQuizState>
    with
        QuestionManagementMixin,
        ResultsManagementMixin,
        ScoringManagementMixin {
  final PostRepo _postRepo;

  CreateQuizCubit(this._postRepo) : super(_initialState);

  // --- Getters ---

  /// Mevcut adım (0-4 arası)
  int get step => state.step;

  /// Süre sınırı var mı?
  bool get hasTimeLimit => state.hasTimeLimit;

  /// Form geçerli mi?
  bool get isFormValid => CreateQuizValidator.validateAllSteps(state);

  /// Puanlama tamamlandı mı?
  bool get isScoringComplete => isAllScoringComplete();

  /// Toplam ilerleme yüzdesi
  double get overallProgress {
    int completedSteps = 0;

    // Her adımı kontrol et
    for (int step = 0; step <= 4; step++) {
      final tempState = state.copyWith(step: step);
      if (CreateQuizValidator.validateCurrentStep(tempState).isValid) {
        completedSteps++;
      }
    }

    return (completedSteps / 5) * 100;
  }

  // --- Basic Info Methods ---

  /// Quiz başlığını günceller
  void titleChanged(String value) {
    emit(state.copyWith(title: value));
  }

  /// Quiz açıklamasını günceller
  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  /// Süre sınırı durumunu değiştirir
  void hasTimeLimitChanged(bool value) {
    emit(
      state.copyWith(
        hasTimeLimit: value,
        expiresAt: value ? state.expiresAt : null,
      ),
    );
  }

  /// Bitiş tarihini günceller
  void expiresAtChanged(DateTime? value) {
    emit(state.copyWith(expiresAt: value));
  }

  // --- Step Navigation ---

  /// Bir önceki adıma geçer
  void previousStep() {
    if (state.step > 0) {
      emit(
        state.copyWith(
          step: state.step - 1,
          status: FormStatus.initial,
          validationErrors: {},
        ),
      );
    }
  }

  /// Bir sonraki adıma geçer (validation ile)
  void nextStep() {
    final validationResult = CreateQuizValidator.validateCurrentStep(state);

    if (!validationResult.isValid) {
      emit(
        state.copyWith(
          status: FormStatus.invalid,
          validationErrors: validationResult.errors,
        ),
      );
      return;
    }

    if (state.step < 4) {
      emit(
        state.copyWith(
          step: state.step + 1,
          status: FormStatus.initial,
          validationErrors: {},
        ),
      );
    }
  }

  /// Belirli bir adıma atlar (validation ile)
  void goToStep(int targetStep) {
    if (targetStep < 0 || targetStep > 4) return;
    if (targetStep == state.step) return;

    // Hedef adımdan önce tüm adımları validate et
    for (int step = 0; step < targetStep; step++) {
      final tempState = state.copyWith(step: step);
      if (!CreateQuizValidator.validateCurrentStep(tempState).isValid) {
        // Geçersiz adım varsa oraya git
        emit(
          state.copyWith(
            step: step,
            status: FormStatus.invalid,
            validationErrors: CreateQuizValidator.validateCurrentStep(
              tempState,
            ).errors,
          ),
        );
        return;
      }
    }

    // Tüm adımlar geçerliyse hedef adıma git
    emit(
      state.copyWith(
        step: targetStep,
        status: FormStatus.initial,
        validationErrors: {},
      ),
    );
  }

  // --- Quiz Publishing ---

  /// Quiz'i yayınlar
  Future<void> publishQuiz() async {
    if (!CreateQuizValidator.validateAllSteps(state)) {
      emit(
        state.copyWith(
          status: FormStatus.submissionFailure,
          errorMessage: "Lütfen tüm adımlardaki eksiklikleri giderin.",
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormStatus.submissionInProgress));

    try {
      // CreateQuizModel oluştur
      final createQuizModel = CreateQuizModelBuilder.build(state);

      // Debug mode'da model'i yazdır
      assert(() {
        CreateQuizModelBuilder.debugPrintModel(createQuizModel);
        return true;
      }());

      // Repository üzerinden quiz'i oluştur
      final createdQuiz = await _postRepo.createQuiz(quiz: createQuizModel);

      emit(
        state.copyWith(
          status: FormStatus.submissionSuccess,
          createdQuiz: createdQuiz,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FormStatus.submissionFailure,
          errorMessage: _parseErrorMessage(e),
        ),
      );
    }
  }

  /// Taslak olarak kaydet (gelecekte eklenebilir)
  Future<void> saveDraft() async {
    // TODO: Implement draft saving functionality
    emit(
      state.copyWith(
        status: FormStatus.initial,
        errorMessage: "Taslak kaydetme özelliği yakında gelecek!",
      ),
    );
  }

  // --- Helper Methods ---

  /// Error mesajlarını user-friendly hale getirir
  String _parseErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'İnternet bağlantınızı kontrol edin';
    } else if (errorStr.contains('timeout')) {
      return 'İşlem zaman aşımına uğradı, tekrar deneyin';
    } else if (errorStr.contains('permission')) {
      return 'Bu işlem için yetkiniz bulunmuyor';
    } else if (errorStr.contains('validation')) {
      return 'Girdiğiniz bilgilerde hata var';
    } else {
      return 'Beklenmeyen bir hata oluştu: ${error.toString()}';
    }
  }

  /// Initial state factory
  static CreateQuizState get _initialState {
    return CreateQuizState(
      questions: [
        QuizQuestionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          questionText: '',
          orderIndex: 0,
          options: [],
        ),
      ],
    );
  }

  /// Cubit'i sıfırlar (yeni quiz için)
  void reset() {
    emit(_initialState);
  }

  /// Debug bilgilerini yazdırır
  void debugPrintState() {
    assert(() {
      print('=== CreateQuizCubit Debug ===');
      print('Step: ${state.step}');
      print('Status: ${state.status}');
      print('Title: ${state.title}');
      print('Questions: ${state.questions.length}');
      print('Results: ${state.results.length}');
      print('Scoring: ${state.scoring.length}');
      print('Validation Errors: ${state.validationErrors}');
      print('Overall Progress: ${overallProgress.toStringAsFixed(1)}%');
      print('Is Form Valid: $isFormValid');
      print('Is Scoring Complete: $isScoringComplete');
      print('=== End Debug ===');
      return true;
    }());
  }
}
