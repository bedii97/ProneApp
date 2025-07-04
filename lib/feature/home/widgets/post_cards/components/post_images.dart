import 'package:flutter/material.dart';
import 'package:prone/core/extensions/color_extension.dart';

class PostImages extends StatelessWidget {
  final List<String> imageUrls;

  const PostImages({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    if (imageUrls.length == 1) {
      return _buildSingleImage(context, imageUrls.first);
    } else if (imageUrls.length == 2) {
      return _buildTwoImages(context, imageUrls);
    } else {
      return _buildMultipleImages(context, imageUrls);
    }
  }

  Widget _buildSingleImage(BuildContext context, String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Icon(
                Icons.broken_image,
                color: Theme.of(context).colorScheme.onErrorContainer,
                size: 48,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTwoImages(BuildContext context, List<String> images) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                images[0],
                fit: BoxFit.cover,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    _buildErrorWidget(context),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Image.network(
                images[1],
                fit: BoxFit.cover,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    _buildErrorWidget(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleImages(BuildContext context, List<String> images) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          // İlk resim
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                images[0],
                fit: BoxFit.cover,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    _buildErrorWidget(context),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // 2-3 resim stack
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      images[1],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildErrorWidget(context),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          images[2],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildErrorWidget(context),
                        ),
                      ),
                      //  3'den fazla resim varsa overlay
                      if (images.length > 3)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacityD(0.5),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '+${images.length - 3}',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Icon(
        Icons.broken_image,
        color: Theme.of(context).colorScheme.onErrorContainer,
        size: 32,
      ),
    );
  }
}
