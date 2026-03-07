// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HabitEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  HabitType get type => throw _privateConstructorUsedError;
  List<int> get frequencyDays =>
      throw _privateConstructorUsedError; // 0=Sun..6=Sat
  String? get reminderTime =>
      throw _privateConstructorUsedError; // "HH:mm" format
  String? get unit => throw _privateConstructorUsedError; // Measurable only
  int? get targetValue => throw _privateConstructorUsedError; // Measurable only
  MeasurableTarget? get targetType => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  Priority get priority => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HabitEntityCopyWith<HabitEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitEntityCopyWith<$Res> {
  factory $HabitEntityCopyWith(
          HabitEntity value, $Res Function(HabitEntity) then) =
      _$HabitEntityCopyWithImpl<$Res, HabitEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      HabitType type,
      List<int> frequencyDays,
      String? reminderTime,
      String? unit,
      int? targetValue,
      MeasurableTarget? targetType,
      List<String> tags,
      Priority priority,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$HabitEntityCopyWithImpl<$Res, $Val extends HabitEntity>
    implements $HabitEntityCopyWith<$Res> {
  _$HabitEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? frequencyDays = null,
    Object? reminderTime = freezed,
    Object? unit = freezed,
    Object? targetValue = freezed,
    Object? targetType = freezed,
    Object? tags = null,
    Object? priority = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as HabitType,
      frequencyDays: null == frequencyDays
          ? _value.frequencyDays
          : frequencyDays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      reminderTime: freezed == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      targetValue: freezed == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as int?,
      targetType: freezed == targetType
          ? _value.targetType
          : targetType // ignore: cast_nullable_to_non_nullable
              as MeasurableTarget?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HabitEntityImplCopyWith<$Res>
    implements $HabitEntityCopyWith<$Res> {
  factory _$$HabitEntityImplCopyWith(
          _$HabitEntityImpl value, $Res Function(_$HabitEntityImpl) then) =
      __$$HabitEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      HabitType type,
      List<int> frequencyDays,
      String? reminderTime,
      String? unit,
      int? targetValue,
      MeasurableTarget? targetType,
      List<String> tags,
      Priority priority,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$HabitEntityImplCopyWithImpl<$Res>
    extends _$HabitEntityCopyWithImpl<$Res, _$HabitEntityImpl>
    implements _$$HabitEntityImplCopyWith<$Res> {
  __$$HabitEntityImplCopyWithImpl(
      _$HabitEntityImpl _value, $Res Function(_$HabitEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? type = null,
    Object? frequencyDays = null,
    Object? reminderTime = freezed,
    Object? unit = freezed,
    Object? targetValue = freezed,
    Object? targetType = freezed,
    Object? tags = null,
    Object? priority = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$HabitEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as HabitType,
      frequencyDays: null == frequencyDays
          ? _value._frequencyDays
          : frequencyDays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      reminderTime: freezed == reminderTime
          ? _value.reminderTime
          : reminderTime // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      targetValue: freezed == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as int?,
      targetType: freezed == targetType
          ? _value.targetType
          : targetType // ignore: cast_nullable_to_non_nullable
              as MeasurableTarget?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$HabitEntityImpl implements _HabitEntity {
  const _$HabitEntityImpl(
      {required this.id,
      required this.title,
      required this.type,
      required final List<int> frequencyDays,
      this.reminderTime,
      this.unit,
      this.targetValue,
      this.targetType,
      final List<String> tags = const [],
      this.priority = Priority.medium,
      required this.createdAt,
      required this.updatedAt})
      : _frequencyDays = frequencyDays,
        _tags = tags;

  @override
  final String id;
  @override
  final String title;
  @override
  final HabitType type;
  final List<int> _frequencyDays;
  @override
  List<int> get frequencyDays {
    if (_frequencyDays is EqualUnmodifiableListView) return _frequencyDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_frequencyDays);
  }

// 0=Sun..6=Sat
  @override
  final String? reminderTime;
// "HH:mm" format
  @override
  final String? unit;
// Measurable only
  @override
  final int? targetValue;
// Measurable only
  @override
  final MeasurableTarget? targetType;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final Priority priority;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'HabitEntity(id: $id, title: $title, type: $type, frequencyDays: $frequencyDays, reminderTime: $reminderTime, unit: $unit, targetValue: $targetValue, targetType: $targetType, tags: $tags, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._frequencyDays, _frequencyDays) &&
            (identical(other.reminderTime, reminderTime) ||
                other.reminderTime == reminderTime) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.targetType, targetType) ||
                other.targetType == targetType) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      type,
      const DeepCollectionEquality().hash(_frequencyDays),
      reminderTime,
      unit,
      targetValue,
      targetType,
      const DeepCollectionEquality().hash(_tags),
      priority,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitEntityImplCopyWith<_$HabitEntityImpl> get copyWith =>
      __$$HabitEntityImplCopyWithImpl<_$HabitEntityImpl>(this, _$identity);
}

abstract class _HabitEntity implements HabitEntity {
  const factory _HabitEntity(
      {required final String id,
      required final String title,
      required final HabitType type,
      required final List<int> frequencyDays,
      final String? reminderTime,
      final String? unit,
      final int? targetValue,
      final MeasurableTarget? targetType,
      final List<String> tags,
      final Priority priority,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$HabitEntityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  HabitType get type;
  @override
  List<int> get frequencyDays;
  @override // 0=Sun..6=Sat
  String? get reminderTime;
  @override // "HH:mm" format
  String? get unit;
  @override // Measurable only
  int? get targetValue;
  @override // Measurable only
  MeasurableTarget? get targetType;
  @override
  List<String> get tags;
  @override
  Priority get priority;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$HabitEntityImplCopyWith<_$HabitEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
