import 'package:flutter/material.dart';

class PollDetailErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const PollDetailErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextButton(
              onPressed: onRetry,
              // onPressed: () {
              //   context.read<PollDetailCubit>().loadPoll(pollId);
              // },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
