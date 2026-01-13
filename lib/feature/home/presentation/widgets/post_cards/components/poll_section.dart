import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/poll/poll_model.dart';

import 'poll_option.dart';

class PollSection extends StatelessWidget {
  const PollSection({super.key, required this.poll});

  final PollModel poll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: poll.options.map((option) {
        return PollOption(
          option: option,
          userVoted: poll.userVoted,
          userVotedOptionIds: poll.userVotedOptionIds,
          showResult: poll.canSeeResults,
        );
      }).toList(),
    );
  }
}
