import 'package:prone/feature/post/domain/models/poll_model.dart';

abstract class PollDetailState {
  const PollDetailState();
}

class PollDetailInitial extends PollDetailState {}

class PollDetailLoading extends PollDetailState {}

class PollDetailLoaded extends PollDetailState {
  final PollModel poll;

  const PollDetailLoaded({required this.poll});

  PollDetailLoaded copyWith({
    PollModel? poll,
    bool? hasVoted,
    String? userVoteOptionId,
  }) {
    return PollDetailLoaded(poll: poll ?? this.poll);
  }
}

class PollDetailError extends PollDetailState {
  final String message;

  const PollDetailError({required this.message});
}

class PollDetailVoting extends PollDetailState {
  const PollDetailVoting();
}
