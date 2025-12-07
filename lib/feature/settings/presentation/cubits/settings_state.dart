part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final ThemeData themeData;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String languageCode;

  const SettingsState({
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

  @override
  // TODO: implement props
  List<Object?> get props => [
    themeData,
    isDarkMode,
    notificationsEnabled,
    languageCode,
  ];
}
