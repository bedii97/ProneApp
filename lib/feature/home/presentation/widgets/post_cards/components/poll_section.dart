import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';

import 'poll_option.dart';

class PollSection extends StatelessWidget {
  final PollModel poll;

  const PollSection({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    final bool shouldShowResults = _shouldShowResults();
    return Column(
      children: poll.options.map((option) {
        return PollOption(
          option: option,
          userVoted: poll.userVoted,
          userVoteOptionId: poll.userVoteOptionId,
          showResult: shouldShowResults,
        );
      }).toList(),
    );
  }

  bool _shouldShowResults() {
    if (poll.userVoted) return true;
    if (poll.hasExpired) return true;
    if (!poll.showResultsBeforeVoting) return true;

    return false;
  }
}
