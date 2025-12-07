import 'package:flutter/material.dart';

class SelectedOptionIcon extends StatelessWidget {
  const SelectedOptionIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle,
      color: Theme.of(context).colorScheme.primary,
      size: 18,
    );
  }
}
