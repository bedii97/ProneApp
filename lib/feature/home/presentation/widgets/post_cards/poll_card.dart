import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';

import 'components/post_header.dart';
import 'components/post_content.dart';
import 'components/post_footer.dart';
import 'components/poll_section.dart';

class PollCard extends StatelessWidget {
  final PollModel poll;

  const PollCard({super.key, required this.poll});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      elevation: 3.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () {
            context.push('/poll/${poll.id}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeader(post: poll),
              const SizedBox(height: 16),

              PostContent(post: poll),
              const SizedBox(height: 16),

              PollSection(poll: poll),

              const SizedBox(height: 12),

              PostFooter(post: poll),
            ],
          ),
        ),
      ),
    );
  }
}
