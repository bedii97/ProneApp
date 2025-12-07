import 'package:flutter/material.dart';
import 'package:prone/feature/post/domain/models/option_model.dart';
import 'package:prone/feature/post/domain/models/poll_model.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Görseldeki gibi seçiliyse Primary (Mavi), değilse soluk border
    final borderColor = isUserVoted
        ? colorScheme.primary
        : colorScheme.outline.withOpacity(0.3);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor, // Tema uyumlu kart rengi
        border: Border.all(
          color: borderColor,
          width: isUserVoted ? 2 : 1, // Seçiliyse biraz daha kalın
        ),
        borderRadius: BorderRadius.circular(16), // Görseldeki gibi oval köşeler
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              // Seçenek Metni
              Expanded(
                child: Text(
                  option.text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Yüzde ve İkon Alanı
              if (poll.canSeeResults) ...[
                Text(
                  '%${option.percentage.toStringAsFixed(0)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],

              // Eğer kullanıcı buna oy vermişse Check ikonu göster
              if (isUserVoted) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
