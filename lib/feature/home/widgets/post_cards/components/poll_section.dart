import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';

import 'poll_option.dart';

class PollSection extends StatelessWidget {
  final PollModel poll;

  const PollSection({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: poll.options.map((option) {
        return PollOption(option: option, poll: poll);
      }).toList(),
    );
  }
}
