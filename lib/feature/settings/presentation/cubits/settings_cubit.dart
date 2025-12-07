import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prone/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
    : super(
        SettingsState(
          themeData: AppTheme.light,
          isDarkMode: false,
          notificationsEnabled: true,
          languageCode:
              // Intl.getCurrentLocale(), // Varsayılan dil kodu (İngilizce)
              PlatformDispatcher.instance.locale.languageCode,
        ),
      ) {
    _loadSettingsFromPreferences();
  }

  // Ayarları kaydetmek için SharedPreferences
  Future<void> _saveSettingsToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state.isDarkMode);
    await prefs.setBool('notificationsEnabled', state.notificationsEnabled);
    await prefs.setString(
      'languageCode',
      state.languageCode,
    ); // Dil kodunu kaydet
  }

  // Kaydedilen ayarları yüklemek için SharedPreferences
  Future<void> _loadSettingsFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    final languageCode =
        prefs.getString('languageCode') ??
        PlatformDispatcher
            .instance
            .locale
            .languageCode; // Varsayılan dil İngilizce
    final themeData = isDarkMode ? AppTheme.dark : AppTheme.light;
    timeago.setDefaultLocale(languageCode);
    emit(
      state.copyWith(
        themeData: themeData,
        isDarkMode: isDarkMode,
        notificationsEnabled: notificationsEnabled,
        languageCode: languageCode,
      ),
    );
  }

  // Tema değiştirme
  void toggleTheme() {
    final newIsDarkMode = !state.isDarkMode;
    final newTheme = newIsDarkMode ? AppTheme.dark : AppTheme.light;
    emit(state.copyWith(themeData: newTheme, isDarkMode: newIsDarkMode));
    _saveSettingsToPreferences();
  }

  // Bildirim tercihlerini değiştirme
  void toggleNotifications() {
    final newNotificationsEnabled = !state.notificationsEnabled;
    emit(state.copyWith(notificationsEnabled: newNotificationsEnabled));
    _saveSettingsToPreferences();
  }

  // Dil değiştirme
  void changeLanguage(String newLanguageCode) {
    log('Changing language to: $newLanguageCode');
    timeago.setDefaultLocale(newLanguageCode);
    emit(state.copyWith(languageCode: newLanguageCode));
    _saveSettingsToPreferences();
  }
}
