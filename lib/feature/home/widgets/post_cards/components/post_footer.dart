import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';

class PostFooter extends StatelessWidget {
  final PostModel post;

  const PostFooter({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Toplam Oy: ${post.totalVotes}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
