part of 'settings_cubit.dart';

class SettingsState {
  final ThemeData themeData;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String languageCode;

  SettingsState({
    required this.themeData,
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.languageCode,
  });

  SettingsState copyWith({
    ThemeData? themeData,
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? languageCode,
  }) {
    return SettingsState(
      themeData: themeData ?? this.themeData,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
