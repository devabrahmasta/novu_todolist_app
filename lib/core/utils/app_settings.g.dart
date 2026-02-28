// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      themeMode: json['themeMode'] == null
          ? ThemeMode.dark
          : const ThemeModeConverter().fromJson(json['themeMode'] as int),
      morningReminderTime: json['morningReminderTime'] == null
          ? const TimeOfDayValue(8, 0)
          : const TimeOfDayConverter()
              .fromJson(json['morningReminderTime'] as Map<String, dynamic>),
      afternoonReminderTime: json['afternoonReminderTime'] == null
          ? const TimeOfDayValue(13, 0)
          : const TimeOfDayConverter()
              .fromJson(json['afternoonReminderTime'] as Map<String, dynamic>),
      eveningReminderTime: json['eveningReminderTime'] == null
          ? const TimeOfDayValue(19, 0)
          : const TimeOfDayConverter()
              .fromJson(json['eveningReminderTime'] as Map<String, dynamic>),
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'themeMode': const ThemeModeConverter().toJson(instance.themeMode),
      'morningReminderTime':
          const TimeOfDayConverter().toJson(instance.morningReminderTime),
      'afternoonReminderTime':
          const TimeOfDayConverter().toJson(instance.afternoonReminderTime),
      'eveningReminderTime':
          const TimeOfDayConverter().toJson(instance.eveningReminderTime),
      'hasCompletedOnboarding': instance.hasCompletedOnboarding,
    };
