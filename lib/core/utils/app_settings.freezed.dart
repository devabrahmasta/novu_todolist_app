// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  @ThemeModeConverter()
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get morningReminderTime => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get afternoonReminderTime => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get eveningReminderTime => throw _privateConstructorUsedError;
  bool get hasCompletedOnboarding => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {@ThemeModeConverter() ThemeMode themeMode,
      @TimeOfDayConverter() TimeOfDay morningReminderTime,
      @TimeOfDayConverter() TimeOfDay afternoonReminderTime,
      @TimeOfDayConverter() TimeOfDay eveningReminderTime,
      bool hasCompletedOnboarding});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? morningReminderTime = null,
    Object? afternoonReminderTime = null,
    Object? eveningReminderTime = null,
    Object? hasCompletedOnboarding = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      morningReminderTime: null == morningReminderTime
          ? _value.morningReminderTime
          : morningReminderTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      afternoonReminderTime: null == afternoonReminderTime
          ? _value.afternoonReminderTime
          : afternoonReminderTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      eveningReminderTime: null == eveningReminderTime
          ? _value.eveningReminderTime
          : eveningReminderTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      hasCompletedOnboarding: null == hasCompletedOnboarding
          ? _value.hasCompletedOnboarding
          : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@ThemeModeConverter() ThemeMode themeMode,
      @TimeOfDayConverter() TimeOfDay morningReminderTime,
      @TimeOfDayConverter() TimeOfDay afternoonReminderTime,
      @TimeOfDayConverter() TimeOfDay eveningReminderTime,
      bool hasCompletedOnboarding});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? morningReminderTime = null,
    Object? afternoonReminderTime = null,
    Object? eveningReminderTime = null,
    Object? hasCompletedOnboarding = null,
  }) {
    return _then(_$AppSettingsImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      morningReminderTime: null == morningReminderTime
          ? _value.morningReminderTime
          : morningReminderTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      afternoonReminderTime: null == afternoonReminderTime
          ? _value.afternoonReminderTime
          : afternoonReminderTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      eveningReminderTime: null == eveningReminderTime
          ? _value.eveningReminderTime
          : eveningReminderTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
      hasCompletedOnboarding: null == hasCompletedOnboarding
          ? _value.hasCompletedOnboarding
          : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {@ThemeModeConverter() this.themeMode = ThemeMode.dark,
      @TimeOfDayConverter()
      this.morningReminderTime = const TimeOfDayValue(8, 0),
      @TimeOfDayConverter()
      this.afternoonReminderTime = const TimeOfDayValue(13, 0),
      @TimeOfDayConverter()
      this.eveningReminderTime = const TimeOfDayValue(19, 0),
      this.hasCompletedOnboarding = false});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  @JsonKey()
  @ThemeModeConverter()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  @TimeOfDayConverter()
  final TimeOfDay morningReminderTime;
  @override
  @JsonKey()
  @TimeOfDayConverter()
  final TimeOfDay afternoonReminderTime;
  @override
  @JsonKey()
  @TimeOfDayConverter()
  final TimeOfDay eveningReminderTime;
  @override
  @JsonKey()
  final bool hasCompletedOnboarding;

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, morningReminderTime: $morningReminderTime, afternoonReminderTime: $afternoonReminderTime, eveningReminderTime: $eveningReminderTime, hasCompletedOnboarding: $hasCompletedOnboarding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.morningReminderTime, morningReminderTime) ||
                other.morningReminderTime == morningReminderTime) &&
            (identical(other.afternoonReminderTime, afternoonReminderTime) ||
                other.afternoonReminderTime == afternoonReminderTime) &&
            (identical(other.eveningReminderTime, eveningReminderTime) ||
                other.eveningReminderTime == eveningReminderTime) &&
            (identical(other.hasCompletedOnboarding, hasCompletedOnboarding) ||
                other.hasCompletedOnboarding == hasCompletedOnboarding));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, themeMode, morningReminderTime,
      afternoonReminderTime, eveningReminderTime, hasCompletedOnboarding);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {@ThemeModeConverter() final ThemeMode themeMode,
      @TimeOfDayConverter() final TimeOfDay morningReminderTime,
      @TimeOfDayConverter() final TimeOfDay afternoonReminderTime,
      @TimeOfDayConverter() final TimeOfDay eveningReminderTime,
      final bool hasCompletedOnboarding}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  @ThemeModeConverter()
  ThemeMode get themeMode;
  @override
  @TimeOfDayConverter()
  TimeOfDay get morningReminderTime;
  @override
  @TimeOfDayConverter()
  TimeOfDay get afternoonReminderTime;
  @override
  @TimeOfDayConverter()
  TimeOfDay get eveningReminderTime;
  @override
  bool get hasCompletedOnboarding;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
