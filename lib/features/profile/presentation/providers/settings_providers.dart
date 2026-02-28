import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_settings.dart';
import '../../../../core/utils/settings_service.dart';

part 'settings_providers.g.dart';

/// Riverpod notifier for app settings.
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  late final SettingsService _service;

  @override
  AppSettings build() {
    _service = getIt<SettingsService>();
    return _service.loadSettings();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _service.saveSettings(state);
  }

  Future<void> setMorningReminderTime(TimeOfDay time) async {
    state = state.copyWith(morningReminderTime: time);
    await _service.saveSettings(state);
  }

  Future<void> setAfternoonReminderTime(TimeOfDay time) async {
    state = state.copyWith(afternoonReminderTime: time);
    await _service.saveSettings(state);
  }

  Future<void> setEveningReminderTime(TimeOfDay time) async {
    state = state.copyWith(eveningReminderTime: time);
    await _service.saveSettings(state);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(hasCompletedOnboarding: true);
    await _service.saveSettings(state);
  }
}
