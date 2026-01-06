import 'package:flutter/material.dart';
import 'package:prone/core/extensions/color_extension.dart';
import 'package:prone/feature/post/domain/models/poll/option_model.dart';

class PollOption extends StatelessWidget {
  final OptionModel option;
  // final PollModel poll;
  final bool userVoted;
  final String? userVoteOptionId;
  final bool showResult;

  const PollOption({
    super.key,
    required this.option,
    required this.userVoted,
    required this.userVoteOptionId,
    this.showResult = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showResult) {
      return _buildResultOption(context);
    } else {
      return _buildVoteOption(context);
    }
  }

  Widget _buildResultOption(BuildContext context) {
    final bool isSelectedOption = userVoteOptionId == option.id;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Yüzdeyi gösteren ilerleme çubuğu
          LinearProgressIndicator(
            value: option.percentage / 100,
            minHeight: 44,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              isSelectedOption
                  ? Theme.of(context).colorScheme.primary.withOpacityD(0.8)
                  : Theme.of(context).colorScheme.primary.withOpacityD(0.3),
            ),
          ),
          // Seçenek metni, oy yüzdesi ve kullanıcının seçimi ikonu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option.text,
                    style: TextStyle(
                      fontWeight: isSelectedOption
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                // Yüzde metni
                Row(
                  children: [
                    Text(
                      '${option.percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    // if (isSelectedOption) const SizedBox(width: 8),
                    // if (isSelectedOption) SelectedOptionIcon(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoteOption(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Progress bar - value 0 ve daha neutral renk
          LinearProgressIndicator(
            value: 0,
            minHeight: 44,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.transparent, // Progress gösterme
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option.text,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                // Vote durumunda percentage gösterme!
                Icon(
                  Icons.radio_button_unchecked,
                  color: Theme.of(context).colorScheme.outline,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
