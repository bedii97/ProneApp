import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: poll.authorAvatarUrl != null
                          ? NetworkImage(poll.authorAvatarUrl!)
                          : null,
                      child: poll.authorAvatarUrl == null
                          ? Text(
                              poll.authorUsername[0].toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            poll.authorUsername,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            _formatDate(poll.createdAt),
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    // Poll stats
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${poll.totalVotes} votes',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  poll.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),

                if (poll.body != null && poll.body!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(poll.body!, style: TextStyle(fontSize: 16, height: 1.5)),
                ],
              ],
            ),

            const SizedBox(height: 8),

            // Options Section
            Column(
              children: [
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
              ],
            ),

            // Settings Section
            if (_hasVisibleSettings(poll)) ...[
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  _buildSettingsList(context, poll),
                ],
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
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
      isUserVoted: poll.userVoteOptionId == option.id,
      onTap: poll.canVote
          ? () {
              onVote(option.id);
            }
          : null,
    );
  }

  bool _hasVisibleSettings(PollModel poll) {
    return poll.allowMultipleAnswers ||
        poll.allowAddingOptions ||
        poll.showResultsBeforeVoting ||
        poll.expiresAt != null;
  }

  Widget _buildSettingsList(BuildContext context, PollModel poll) {
    final settings = <Widget>[];

    if (poll.allowMultipleAnswers) {
      settings.add(_buildSettingItem('Multiple answers allowed'));
    }

    if (poll.allowAddingOptions) {
      settings.add(_buildSettingItem('Users can add options'));
    }

    if (poll.showResultsBeforeVoting) {
      settings.add(_buildSettingItem('Results visible before voting'));
    }

    if (poll.expiresAt != null) {
      settings.add(
        _buildSettingItem('Expires ${_formatDate(poll.expiresAt!)}'),
      );
    }

    return Column(
      children: settings
          .expand((widget) => [widget, const SizedBox(height: 8)])
          .take(settings.length * 2 - 1)
          .toList(),
    );
  }

  Widget _buildSettingItem(String text) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
      ],
    );
  }

  String _formatDate(DateTime date) {
    // return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    return DateFormat.yMMMd().add_jm().format(date);
  }
}
