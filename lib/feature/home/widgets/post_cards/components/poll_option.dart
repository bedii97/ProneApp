import 'package:flutter/material.dart';
import 'package:prone/core/extensions/color_extension.dart';
import 'package:prone/feature/post/domain/models/option_model.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';

class PollOption extends StatelessWidget {
  final OptionModel option;
  final PollModel poll;

  const PollOption({super.key, required this.option, required this.poll});

  @override
  Widget build(BuildContext context) {
    if (poll.userVoted) {
      return _buildResultOption(context);
    } else {
      return _buildVoteOption(context);
    }
  }

  Widget _buildResultOption(BuildContext context) {
    final bool isSelectedOption = poll.userVoteOption == option.id;

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
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.primary.withOpacityD(0.3), // Daha soluk
            ),
          ),
          // Seçenek metni, oy yüzdesi ve kullanıcının seçimi ikonu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        option.text,
                        style: TextStyle(
                          fontWeight: isSelectedOption
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (isSelectedOption) const SizedBox(width: 8),
                    ],
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
                    if (isSelectedOption) const SizedBox(width: 8),
                    if (isSelectedOption)
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 44),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          // TODO: Oy verme işlemi
          //print('Oy verildi: ${option.text}');
        },
        child: Text(option.text),
      ),
    );
  }
}
