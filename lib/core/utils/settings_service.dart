import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';

/// Service for persisting AppSettings via SharedPreferences.
@lazySingleton
class SettingsService {
  static const _key = 'app_settings';
  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  /// Load current settings. Returns defaults if nothing stored.
  AppSettings loadSettings() {
    final jsonString = _prefs.getString(_key);
    if (jsonString == null) return const AppSettings();
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppSettings.fromJson(json);
    } catch (_) {
      return const AppSettings();
    }
  }

  /// Persist settings to SharedPreferences.
  Future<void> saveSettings(AppSettings settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await _prefs.setString(_key, jsonString);
  }
}
