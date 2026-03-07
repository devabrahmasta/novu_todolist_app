// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_goal_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HabitGoalEntity {
  String get id => throw _privateConstructorUsedError;
  String get habitId => throw _privateConstructorUsedError;
  int get targetDays => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int get currentProgress => throw _privateConstructorUsedError;
  HabitGoalStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HabitGoalEntityCopyWith<HabitGoalEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitGoalEntityCopyWith<$Res> {
  factory $HabitGoalEntityCopyWith(
          HabitGoalEntity value, $Res Function(HabitGoalEntity) then) =
      _$HabitGoalEntityCopyWithImpl<$Res, HabitGoalEntity>;
  @useResult
  $Res call(
      {String id,
      String habitId,
      int targetDays,
      DateTime startDate,
      DateTime endDate,
      int currentProgress,
      HabitGoalStatus status,
      DateTime createdAt});
}

/// @nodoc
class _$HabitGoalEntityCopyWithImpl<$Res, $Val extends HabitGoalEntity>
    implements $HabitGoalEntityCopyWith<$Res> {
  _$HabitGoalEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? habitId = null,
    Object? targetDays = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? currentProgress = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      habitId: null == habitId
          ? _value.habitId
          : habitId // ignore: cast_nullable_to_non_nullable
              as String,
      targetDays: null == targetDays
          ? _value.targetDays
          : targetDays // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HabitGoalStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HabitGoalEntityImplCopyWith<$Res>
    implements $HabitGoalEntityCopyWith<$Res> {
  factory _$$HabitGoalEntityImplCopyWith(_$HabitGoalEntityImpl value,
          $Res Function(_$HabitGoalEntityImpl) then) =
      __$$HabitGoalEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String habitId,
      int targetDays,
      DateTime startDate,
      DateTime endDate,
      int currentProgress,
      HabitGoalStatus status,
      DateTime createdAt});
}

/// @nodoc
class __$$HabitGoalEntityImplCopyWithImpl<$Res>
    extends _$HabitGoalEntityCopyWithImpl<$Res, _$HabitGoalEntityImpl>
    implements _$$HabitGoalEntityImplCopyWith<$Res> {
  __$$HabitGoalEntityImplCopyWithImpl(
      _$HabitGoalEntityImpl _value, $Res Function(_$HabitGoalEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? habitId = null,
    Object? targetDays = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? currentProgress = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_$HabitGoalEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      habitId: null == habitId
          ? _value.habitId
          : habitId // ignore: cast_nullable_to_non_nullable
              as String,
      targetDays: null == targetDays
          ? _value.targetDays
          : targetDays // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HabitGoalStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$HabitGoalEntityImpl implements _HabitGoalEntity {
  const _$HabitGoalEntityImpl(
      {required this.id,
      required this.habitId,
      required this.targetDays,
      required this.startDate,
      required this.endDate,
      this.currentProgress = 0,
      this.status = HabitGoalStatus.active,
      required this.createdAt});

  @override
  final String id;
  @override
  final String habitId;
  @override
  final int targetDays;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final int currentProgress;
  @override
  @JsonKey()
  final HabitGoalStatus status;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'HabitGoalEntity(id: $id, habitId: $habitId, targetDays: $targetDays, startDate: $startDate, endDate: $endDate, currentProgress: $currentProgress, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitGoalEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.habitId, habitId) || other.habitId == habitId) &&
            (identical(other.targetDays, targetDays) ||
                other.targetDays == targetDays) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.currentProgress, currentProgress) ||
                other.currentProgress == currentProgress) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, habitId, targetDays,
      startDate, endDate, currentProgress, status, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitGoalEntityImplCopyWith<_$HabitGoalEntityImpl> get copyWith =>
      __$$HabitGoalEntityImplCopyWithImpl<_$HabitGoalEntityImpl>(
          this, _$identity);
}

abstract class _HabitGoalEntity implements HabitGoalEntity {
  const factory _HabitGoalEntity(
      {required final String id,
      required final String habitId,
      required final int targetDays,
      required final DateTime startDate,
      required final DateTime endDate,
      final int currentProgress,
      final HabitGoalStatus status,
      required final DateTime createdAt}) = _$HabitGoalEntityImpl;

  @override
  String get id;
  @override
  String get habitId;
  @override
  int get targetDays;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int get currentProgress;
  @override
  HabitGoalStatus get status;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$HabitGoalEntityImplCopyWith<_$HabitGoalEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
