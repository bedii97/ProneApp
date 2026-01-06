import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/feature/post/domain/models/poll/poll_model.dart';
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

  PollModel _optimisticVote(PollModel currentPoll, String selectedOptionId) {
    // Update the selected option's vote count
    final updatedOptions = currentPoll.options.map((option) {
      if (option.id == selectedOptionId) {
        return option.copyWith(votes: option.votes + 1);
      }
      return option;
    }).toList();

    // Calculate new total votes
    final newTotalVotes = currentPoll.totalVotes + 1;

    // Recalculate percentages
    final optionsWithPercentages = updatedOptions.map((option) {
      final percentage = newTotalVotes > 0
          ? (option.votes / newTotalVotes * 100)
          : 0.0;
      return option.copyWith(percentage: percentage);
    }).toList();

    return currentPoll.copyWith(
      options: optionsWithPercentages,
      totalVotes: newTotalVotes,
      userVoted: true,
      userVoteOptionId: selectedOptionId,
    );
  }

  Future<void> vote(String pollId, List<String> optionIds) async {
    try {
      final currentState = state;
      if (currentState is! PollDetailLoaded) return;

      final updatedPoll = _optimisticVote(currentState.poll, optionIds.first);
      emit(PollDetailLoaded(poll: updatedPoll));
      // Oylama işlemini gerçekleştir
      await _postRepo.voteOnPoll(pollId: pollId, optionIds: optionIds);

      // Güncellenmiş anket verisini tekrar yükle
      final realUpdatedPoll = await _postRepo.getPollById(pollId);
      emit(PollDetailLoaded(poll: realUpdatedPoll));
    } catch (e) {
      emit(PollDetailError(message: e.toString()));
    }
  }
}
