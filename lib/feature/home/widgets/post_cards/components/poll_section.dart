import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'poll_option.dart';

class PollSection extends StatelessWidget {
  final PostModel post;

  const PollSection({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: post.options.map((option) {
        return PollOption(option: option, post: post);
      }).toList(),
    );
  }
}
