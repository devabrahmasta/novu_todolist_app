// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TaskAnalytics {
  int get streak => throw _privateConstructorUsedError;
  int get totalCompletions => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<bool> get weeklyData =>
      throw _privateConstructorUsedError; // last 7 days
  List<bool> get monthlyData =>
      throw _privateConstructorUsedError; // last 30 days
  int get bestStreak => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TaskAnalyticsCopyWith<TaskAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskAnalyticsCopyWith<$Res> {
  factory $TaskAnalyticsCopyWith(
          TaskAnalytics value, $Res Function(TaskAnalytics) then) =
      _$TaskAnalyticsCopyWithImpl<$Res, TaskAnalytics>;
  @useResult
  $Res call(
      {int streak,
      int totalCompletions,
      DateTime createdAt,
      List<bool> weeklyData,
      List<bool> monthlyData,
      int bestStreak});
}

/// @nodoc
class _$TaskAnalyticsCopyWithImpl<$Res, $Val extends TaskAnalytics>
    implements $TaskAnalyticsCopyWith<$Res> {
  _$TaskAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streak = null,
    Object? totalCompletions = null,
    Object? createdAt = null,
    Object? weeklyData = null,
    Object? monthlyData = null,
    Object? bestStreak = null,
  }) {
    return _then(_value.copyWith(
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      totalCompletions: null == totalCompletions
          ? _value.totalCompletions
          : totalCompletions // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weeklyData: null == weeklyData
          ? _value.weeklyData
          : weeklyData // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      monthlyData: null == monthlyData
          ? _value.monthlyData
          : monthlyData // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      bestStreak: null == bestStreak
          ? _value.bestStreak
          : bestStreak // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskAnalyticsImplCopyWith<$Res>
    implements $TaskAnalyticsCopyWith<$Res> {
  factory _$$TaskAnalyticsImplCopyWith(
          _$TaskAnalyticsImpl value, $Res Function(_$TaskAnalyticsImpl) then) =
      __$$TaskAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int streak,
      int totalCompletions,
      DateTime createdAt,
      List<bool> weeklyData,
      List<bool> monthlyData,
      int bestStreak});
}

/// @nodoc
class __$$TaskAnalyticsImplCopyWithImpl<$Res>
    extends _$TaskAnalyticsCopyWithImpl<$Res, _$TaskAnalyticsImpl>
    implements _$$TaskAnalyticsImplCopyWith<$Res> {
  __$$TaskAnalyticsImplCopyWithImpl(
      _$TaskAnalyticsImpl _value, $Res Function(_$TaskAnalyticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streak = null,
    Object? totalCompletions = null,
    Object? createdAt = null,
    Object? weeklyData = null,
    Object? monthlyData = null,
    Object? bestStreak = null,
  }) {
    return _then(_$TaskAnalyticsImpl(
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      totalCompletions: null == totalCompletions
          ? _value.totalCompletions
          : totalCompletions // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weeklyData: null == weeklyData
          ? _value._weeklyData
          : weeklyData // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      monthlyData: null == monthlyData
          ? _value._monthlyData
          : monthlyData // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      bestStreak: null == bestStreak
          ? _value.bestStreak
          : bestStreak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TaskAnalyticsImpl implements _TaskAnalytics {
  const _$TaskAnalyticsImpl(
      {required this.streak,
      required this.totalCompletions,
      required this.createdAt,
      required final List<bool> weeklyData,
      required final List<bool> monthlyData,
      required this.bestStreak})
      : _weeklyData = weeklyData,
        _monthlyData = monthlyData;

  @override
  final int streak;
  @override
  final int totalCompletions;
  @override
  final DateTime createdAt;
  final List<bool> _weeklyData;
  @override
  List<bool> get weeklyData {
    if (_weeklyData is EqualUnmodifiableListView) return _weeklyData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyData);
  }

// last 7 days
  final List<bool> _monthlyData;
// last 7 days
  @override
  List<bool> get monthlyData {
    if (_monthlyData is EqualUnmodifiableListView) return _monthlyData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthlyData);
  }

// last 30 days
  @override
  final int bestStreak;

  @override
  String toString() {
    return 'TaskAnalytics(streak: $streak, totalCompletions: $totalCompletions, createdAt: $createdAt, weeklyData: $weeklyData, monthlyData: $monthlyData, bestStreak: $bestStreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskAnalyticsImpl &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.totalCompletions, totalCompletions) ||
                other.totalCompletions == totalCompletions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._weeklyData, _weeklyData) &&
            const DeepCollectionEquality()
                .equals(other._monthlyData, _monthlyData) &&
            (identical(other.bestStreak, bestStreak) ||
                other.bestStreak == bestStreak));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      streak,
      totalCompletions,
      createdAt,
      const DeepCollectionEquality().hash(_weeklyData),
      const DeepCollectionEquality().hash(_monthlyData),
      bestStreak);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskAnalyticsImplCopyWith<_$TaskAnalyticsImpl> get copyWith =>
      __$$TaskAnalyticsImplCopyWithImpl<_$TaskAnalyticsImpl>(this, _$identity);
}

abstract class _TaskAnalytics implements TaskAnalytics {
  const factory _TaskAnalytics(
      {required final int streak,
      required final int totalCompletions,
      required final DateTime createdAt,
      required final List<bool> weeklyData,
      required final List<bool> monthlyData,
      required final int bestStreak}) = _$TaskAnalyticsImpl;

  @override
  int get streak;
  @override
  int get totalCompletions;
  @override
  DateTime get createdAt;
  @override
  List<bool> get weeklyData;
  @override // last 7 days
  List<bool> get monthlyData;
  @override // last 30 days
  int get bestStreak;
  @override
  @JsonKey(ignore: true)
  _$$TaskAnalyticsImplCopyWith<_$TaskAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
