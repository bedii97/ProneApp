import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'components/post_header.dart';
import 'components/post_content.dart';
import 'components/post_footer.dart';
import 'components/poll_section.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(post: post),
            const SizedBox(height: 16),

            PostContent(post: post),
            const SizedBox(height: 16),
            if (post.type == PostType.poll) PollSection(post: post),
            const SizedBox(height: 12),

            PostFooter(post: post),
          ],
        ),
      ),
    );
  }
}
