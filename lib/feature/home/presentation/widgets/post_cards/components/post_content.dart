import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/post_model.dart';
import 'post_images.dart';

class PostContent extends StatelessWidget {
  final PostModel post;

  const PostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        Text(
          post.title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),

        // Body metni
        if (post.body != null && post.body!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              post.body!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ),

        // Resimler
        if (post.imageUrls != null && post.imageUrls!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: PostImages(imageUrls: post.imageUrls!),
          ),
      ],
    );
  }
}
