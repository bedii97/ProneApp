import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/option_model.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';
import 'package:prone/feature/post/presentation/widgets/selected_option_icon.dart';

class PollOptionTile extends StatelessWidget {
  final PollModel poll;
  final OptionModel option;
  final VoidCallback? onTap;
  final bool isUserVoted;
  const PollOptionTile({
    super.key,
    required this.poll,
    required this.option,
    this.onTap,
    this.isUserVoted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          // color: Theme.of(context).dividerColor,
          color: isUserVoted
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      option.text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (poll.canSeeResults) ...[
                    Text(
                      '${option.votes}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),

              if (poll.canSeeResults) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: option.percentage / 100,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Theme.of(context).dividerColor,
                              color: isUserVoted
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${option.percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        // color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
