// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_step_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HabitStepEntity {
  String get id => throw _privateConstructorUsedError;
  String get habitId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HabitStepEntityCopyWith<HabitStepEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitStepEntityCopyWith<$Res> {
  factory $HabitStepEntityCopyWith(
          HabitStepEntity value, $Res Function(HabitStepEntity) then) =
      _$HabitStepEntityCopyWithImpl<$Res, HabitStepEntity>;
  @useResult
  $Res call({String id, String habitId, String title, int order});
}

/// @nodoc
class _$HabitStepEntityCopyWithImpl<$Res, $Val extends HabitStepEntity>
    implements $HabitStepEntityCopyWith<$Res> {
  _$HabitStepEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? habitId = null,
    Object? title = null,
    Object? order = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HabitStepEntityImplCopyWith<$Res>
    implements $HabitStepEntityCopyWith<$Res> {
  factory _$$HabitStepEntityImplCopyWith(_$HabitStepEntityImpl value,
          $Res Function(_$HabitStepEntityImpl) then) =
      __$$HabitStepEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String habitId, String title, int order});
}

/// @nodoc
class __$$HabitStepEntityImplCopyWithImpl<$Res>
    extends _$HabitStepEntityCopyWithImpl<$Res, _$HabitStepEntityImpl>
    implements _$$HabitStepEntityImplCopyWith<$Res> {
  __$$HabitStepEntityImplCopyWithImpl(
      _$HabitStepEntityImpl _value, $Res Function(_$HabitStepEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? habitId = null,
    Object? title = null,
    Object? order = null,
  }) {
    return _then(_$HabitStepEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      habitId: null == habitId
          ? _value.habitId
          : habitId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$HabitStepEntityImpl implements _HabitStepEntity {
  const _$HabitStepEntityImpl(
      {required this.id,
      required this.habitId,
      required this.title,
      required this.order});

  @override
  final String id;
  @override
  final String habitId;
  @override
  final String title;
  @override
  final int order;

  @override
  String toString() {
    return 'HabitStepEntity(id: $id, habitId: $habitId, title: $title, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitStepEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.habitId, habitId) || other.habitId == habitId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, habitId, title, order);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitStepEntityImplCopyWith<_$HabitStepEntityImpl> get copyWith =>
      __$$HabitStepEntityImplCopyWithImpl<_$HabitStepEntityImpl>(
          this, _$identity);
}

abstract class _HabitStepEntity implements HabitStepEntity {
  const factory _HabitStepEntity(
      {required final String id,
      required final String habitId,
      required final String title,
      required final int order}) = _$HabitStepEntityImpl;

  @override
  String get id;
  @override
  String get habitId;
  @override
  String get title;
  @override
  int get order;
  @override
  @JsonKey(ignore: true)
  _$$HabitStepEntityImplCopyWith<_$HabitStepEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
