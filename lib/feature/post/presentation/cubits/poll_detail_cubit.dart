import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/repos/post_repo.dart';
import 'package:prone/feature/post/presentation/cubits/poll_detail_state.dart';

class PollDetailCubit extends Cubit<PollDetailState> {
  final PostRepo _postRepo;

  PollDetailCubit({required PostRepo postRepo})
    : _postRepo = postRepo,
      super(PollDetailInitial());

  Future<void> loadPoll(String pollId) async {
    try {
      emit(PollDetailLoading());

      // Poll'u getir
      final poll = await _postRepo.getPollById(pollId);

      emit(PollDetailLoaded(poll: poll));
    } catch (e) {
      emit(PollDetailError(message: e.toString()));
    }
  }

  Future<void> vote(String pollId, List<String> optionIds) async {
    try {
      // final poll = (state as PollDetailLoaded).poll.copyWith(
      //   userVoted: true,
      //   userVoteOptionId: optionIds.first,
      // );
      emit(PollDetailVoting());

      // Oylama işlemini gerçekleştir
      await _postRepo.voteOnPoll(pollId: pollId, optionIds: optionIds);

      // Güncellenmiş anket verisini tekrar yükle
      final updatedPoll = await _postRepo.getPollById(pollId);
      emit(PollDetailLoaded(poll: updatedPoll));
    } catch (e) {
      emit(PollDetailError(message: e.toString()));
    }
  }
}
