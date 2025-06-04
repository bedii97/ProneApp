import 'package:flutter/material.dart';

class AppColors {
  // Vote colors - modern social media style
  static const Color upvoteColorLight = Color(0xff3f5f90);
  static const Color upvoteColorDark = Color(0xff6B9EFF);
  static const Color downvoteColorLight = Color(0xff555f71);
  static const Color downvoteColorDark = Color(0xff8A94A6);
  static const Color voteColorLight = Color(0xff555f71);
  static const Color voteColorDark = Color(0xff8A94A6);

  // Tag and category colors
  static const Color tagColorLight = Color(0xFF2196F3);
  static const Color tagColorDark = Color(0xFF90CAF9);
  static const Color dateTextColorLight = Color(0xff6B7280);
  static const Color dateTextColorDark = Color(0xff9CA3AF);

  // Quiz and poll specific colors
  static const Color correctAnswerLight = Color(0xff10B981);
  static const Color correctAnswerDark = Color(0xff34D399);
  static const Color incorrectAnswerLight = Color(0xffEF4444);
  static const Color incorrectAnswerDark = Color(0xffF87171);
  static const Color neutralAnswerLight = Color(0xff6B7280);
  static const Color neutralAnswerDark = Color(0xff9CA3AF);

  // Poll option colors
  static const Color pollOptionALight = Color(0xff3B82F6);
  static const Color pollOptionADark = Color(0xff60A5FA);
  static const Color pollOptionBLight = Color(0xff8B5CF6);
  static const Color pollOptionBDark = Color(0xffA78BFA);
  static const Color pollOptionCLight = Color(0xffF59E0B);
  static const Color pollOptionCDark = Color(0xffFBBF24);
  static const Color pollOptionDLight = Color(0xffEF4444);
  static const Color pollOptionDDark = Color(0xffF87171);
}

//extension for color scheme
extension AppColorsExtension on ColorScheme {
  Color get upvoteColor => brightness == Brightness.light
      ? AppColors.upvoteColorLight
      : AppColors.upvoteColorDark;
  Color get downvoteColor => brightness == Brightness.light
      ? AppColors.downvoteColorLight
      : AppColors.downvoteColorDark;
  Color get voteColor => brightness == Brightness.light
      ? AppColors.voteColorLight
      : AppColors.voteColorDark;
  Color get tagColor => brightness == Brightness.light
      ? AppColors.tagColorLight
      : AppColors.tagColorDark;
  Color get dateTextColor => brightness == Brightness.light
      ? AppColors.dateTextColorLight
      : AppColors.dateTextColorDark;

  // Quiz and poll specific colors
  Color get correctAnswer => brightness == Brightness.light
      ? AppColors.correctAnswerLight
      : AppColors.correctAnswerDark;
  Color get incorrectAnswer => brightness == Brightness.light
      ? AppColors.incorrectAnswerLight
      : AppColors.incorrectAnswerDark;
  Color get neutralAnswer => brightness == Brightness.light
      ? AppColors.neutralAnswerLight
      : AppColors.neutralAnswerDark;

  // Poll option colors
  Color get pollOptionA => brightness == Brightness.light
      ? AppColors.pollOptionALight
      : AppColors.pollOptionADark;
  Color get pollOptionB => brightness == Brightness.light
      ? AppColors.pollOptionBLight
      : AppColors.pollOptionBDark;
  Color get pollOptionC => brightness == Brightness.light
      ? AppColors.pollOptionCLight
      : AppColors.pollOptionCDark;
  Color get pollOptionD => brightness == Brightness.light
      ? AppColors.pollOptionDLight
      : AppColors.pollOptionDDark;
}

sealed class AppTheme {
  static ThemeData light = ThemeData(
    colorScheme: AppTheme.lightColorScheme,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  static ThemeData dark = ThemeData(
    colorScheme: AppTheme.darkColorScheme,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );

  /// Light [ColorScheme] made with FlexColorScheme v8.0.1.
  /// Requires Flutter 3.22.0 or later.
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff3f5f90),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffd6e3ff),
    onPrimaryContainer: Color(0xff001b3d),
    primaryFixed: Color(0xffd6e3ff),
    primaryFixedDim: Color(0xffa8c8ff),
    onPrimaryFixed: Color(0xff001b3d),
    onPrimaryFixedVariant: Color(0xff254777),
    secondary: Color(0xff555f71),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffd9e3f8),
    onSecondaryContainer: Color(0xff121c2b),
    secondaryFixed: Color(0xffd9e3f8),
    secondaryFixedDim: Color(0xffbdc7dc),
    onSecondaryFixed: Color(0xff121c2b),
    onSecondaryFixedVariant: Color(0xff3e4758),
    tertiary: Color(0xff6f5675),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xfff9d8fe),
    onTertiaryContainer: Color(0xff28132f),
    tertiaryFixed: Color(0xfff9d8fe),
    tertiaryFixedDim: Color(0xffdcbce1),
    onTertiaryFixed: Color(0xff28132f),
    onTertiaryFixedVariant: Color(0xff563e5c),
    error: Color(0xffba1a1a),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff410002),
    surface: Color(0xfff9f9ff),
    onSurface: Color(0xff191c20),
    surfaceDim: Color(0xffd9d9e0),
    surfaceBright: Color(0xfff9f9ff),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff3f3fa),
    surfaceContainer: Color(0xffededf4),
    surfaceContainerHigh: Color(0xffe7e8ee),
    surfaceContainerHighest: Color(0xffe2e2e9),
    onSurfaceVariant: Color(0xff43474e),
    outline: Color(0xff74777f),
    outlineVariant: Color(0xffc4c6cf),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2e3035),
    onInverseSurface: Color(0xfff0f0f7),
    inversePrimary: Color(0xffa8c8ff),
    surfaceTint: Color(0xff3f5f90),
  );

  /// Dark [ColorScheme] made with FlexColorScheme v8.0.1.
  /// Requires Flutter 3.22.0 or later.
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffa8c8ff),
    onPrimary: Color(0xff07305f),
    primaryContainer: Color(0xff254777),
    onPrimaryContainer: Color(0xffd6e3ff),
    primaryFixed: Color(0xffd6e3ff),
    primaryFixedDim: Color(0xffa8c8ff),
    onPrimaryFixed: Color(0xff001b3d),
    onPrimaryFixedVariant: Color(0xff254777),
    secondary: Color(0xffbdc7dc),
    onSecondary: Color(0xff273141),
    secondaryContainer: Color(0xff3e4758),
    onSecondaryContainer: Color(0xffd9e3f8),
    secondaryFixed: Color(0xffd9e3f8),
    secondaryFixedDim: Color(0xffbdc7dc),
    onSecondaryFixed: Color(0xff121c2b),
    onSecondaryFixedVariant: Color(0xff3e4758),
    tertiary: Color(0xffdcbce1),
    onTertiary: Color(0xff3e2845),
    tertiaryContainer: Color(0xff563e5c),
    onTertiaryContainer: Color(0xfff9d8fe),
    tertiaryFixed: Color(0xfff9d8fe),
    tertiaryFixedDim: Color(0xffdcbce1),
    onTertiaryFixed: Color(0xff28132f),
    onTertiaryFixedVariant: Color(0xff563e5c),
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffdad6),
    surface: Color(0xff111318),
    onSurface: Color(0xffe2e2e9),
    surfaceDim: Color(0xff111318),
    surfaceBright: Color(0xff37393e),
    surfaceContainerLowest: Color(0xff0c0e13),
    surfaceContainerLow: Color(0xff191c20),
    surfaceContainer: Color(0xff1d2024),
    surfaceContainerHigh: Color(0xff282a2f),
    surfaceContainerHighest: Color(0xff33353a),
    onSurfaceVariant: Color(0xffc4c6cf),
    outline: Color(0xff8e9099),
    outlineVariant: Color(0xff43474e),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe2e2e9),
    onInverseSurface: Color(0xff2e3035),
    inversePrimary: Color(0xff3f5f90),
    surfaceTint: Color(0xffa8c8ff),
  );
}
