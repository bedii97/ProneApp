// ignore_for_file: unreachable_switch_default

import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'package:prone/feature/post/domain/models/quiz_model.dart';

class PostFooter extends StatelessWidget {
  final PostModel post;

  const PostFooter({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          _getFooterText(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getFooterText() {
    switch (post.type) {
      case PostType.poll:
        final pollPost = post as PollModel;
        return 'Toplam Oy: ${pollPost.totalVotes}';

      case PostType.quiz:
        final quizPost = post as QuizModel;
        return 'Katılımcı: ${quizPost.totalParticipants}';

      default:
        return '';
    }
  }
}
