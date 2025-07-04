import 'package:flutter/material.dart';

extension ColorOpacityExtension on Color {
  Color withOpacityD(double opacity) {
    final validOpacity = opacity.clamp(0.0, 1.0);
    return withAlpha((255 * validOpacity).round());
  }
}
