import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Application settings persisted via SharedPreferences.
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(ThemeMode.dark) @ThemeModeConverter() ThemeMode themeMode,
    @Default(TimeOfDayValue(8, 0))
    @TimeOfDayConverter()
    TimeOfDay morningReminderTime,
    @Default(TimeOfDayValue(13, 0))
    @TimeOfDayConverter()
    TimeOfDay afternoonReminderTime,
    @Default(TimeOfDayValue(19, 0))
    @TimeOfDayConverter()
    TimeOfDay eveningReminderTime,
    @Default(false) bool hasCompletedOnboarding,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}

/// Constant TimeOfDay value for use in @Default annotations.
class TimeOfDayValue implements TimeOfDay {
  @override
  final int hour;
  @override
  final int minute;

  const TimeOfDayValue(this.hour, this.minute);

  @override
  DayPeriod get period => hour < 12 ? DayPeriod.am : DayPeriod.pm;

  @override
  int get hourOfPeriod => hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

  @override
  String format(BuildContext context) =>
      MaterialLocalizations.of(context).formatTimeOfDay(this);

  @override
  bool operator ==(Object other) =>
      other is TimeOfDay && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => 'TimeOfDay(hour: $hour, minute: $minute)';

  @override
  // ignore: no need for override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// JSON converter for ThemeMode.
class ThemeModeConverter implements JsonConverter<ThemeMode, int> {
  const ThemeModeConverter();

  @override
  ThemeMode fromJson(int json) => ThemeMode.values[json];

  @override
  int toJson(ThemeMode object) => object.index;
}

/// JSON converter for TimeOfDay.
class TimeOfDayConverter
    implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) =>
      TimeOfDay(hour: json['hour'] as int, minute: json['minute'] as int);

  @override
  Map<String, dynamic> toJson(TimeOfDay object) => {
    'hour': object.hour,
    'minute': object.minute,
  };
}
