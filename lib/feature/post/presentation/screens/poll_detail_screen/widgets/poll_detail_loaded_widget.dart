import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prone/core/extensions/timeago_extension.dart';
import 'package:prone/feature/post/domain/models/option_model.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';
import 'package:prone/feature/post/presentation/screens/poll_detail_screen/widgets/poll_option_tile.dart';

class PollDetailLoadedWidget extends StatelessWidget {
  final PollModel poll;
  final Function(String optionId) onVote;

  const PollDetailLoadedWidget({
    super.key,
    required this.poll,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Header
                  _buildUserInfoHeader(context),

                  const SizedBox(height: 24),

                  //Title
                  Text(
                    poll.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  // Body
                  if (poll.body != null && poll.body!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      poll.body!, // "Aşağıdaki seçeneklerden..."
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.8,
                        ),
                        height: 1.5,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Tags Row
                  _buildTagsRow(context),

                  const SizedBox(height: 32),

                  // Options List
                  ...poll.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    return _buildPollOption(
                      context,
                      option,
                      index,
                      poll,
                      poll.userVoteOptionId == option.id,
                    );
                  }),

                  const SizedBox(height: 16),

                  // Total Votes Info
                  Text(
                    'Toplam ${NumberFormat('#,###').format(poll.totalVotes)} oy',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),

        // Bottom Action Bar (Like, Comment, Share)
        _buildBottomActionBar(context),
      ],
    );
  }

  Widget _buildUserInfoHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: poll.authorAvatarUrl != null
              ? NetworkImage(poll.authorAvatarUrl!)
              : null,
          child: poll.authorAvatarUrl == null
              ? Text(poll.authorUsername[0].toUpperCase())
              : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poll.authorUsername,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              poll.createdAt.timeAgo(context),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsRow(BuildContext context) {
    final tags = <Widget>[];

    if (poll.allowMultipleAnswers) {
      tags.add(_buildChip(context, Icons.grid_view_rounded, "Çoklu Cevap"));
    }
    if (poll.allowAddingOptions) {
      tags.add(
        _buildChip(context, Icons.add_circle_outline, "Seçenek Eklenebilir"),
      );
    }
    // Örnek: Sonuçlar Gizli ise
    if (!poll.showResultsBeforeVoting) {
      tags.add(
        _buildChip(context, Icons.visibility_off_outlined, "Sonuçlar Gizli"),
      );
    }

    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 8, runSpacing: 8, children: tags);
  }

  Widget _buildChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // veya surface color
        border: Border(
          top: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Beğeni
          _buildActionItem(
            context,
            Icons.favorite,
            "256",
            color: Colors.redAccent,
          ),
          // Yorum
          _buildActionItem(context, Icons.chat_bubble_outline, "12"),
          // Paylaş
          _buildActionItem(context, Icons.ios_share, "Paylaş"),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    IconData icon,
    String label, {
    Color? color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color ?? Theme.of(context).iconTheme.color, size: 26),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildPollOption(
    BuildContext context,
    OptionModel option,
    int index,
    PollModel poll,
    bool isUserVoted,
  ) {
    return PollOptionTile(
      poll: poll,
      option: option,
      isUserVoted: isUserVoted,
      onTap: poll.canVote ? () => onVote(option.id) : null,
    );
  }
}
