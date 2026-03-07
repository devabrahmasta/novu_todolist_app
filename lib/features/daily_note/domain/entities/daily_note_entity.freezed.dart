// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_note_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DailyNoteEntity {
  String get id => throw _privateConstructorUsedError;
  String get date =>
      throw _privateConstructorUsedError; // "yyyy-MM-dd", unique per day
  String? get text => throw _privateConstructorUsedError; // max 200 chars
  String? get photoPath =>
      throw _privateConstructorUsedError; // local file path, Pro only
  int? get mood =>
      throw _privateConstructorUsedError; // 0–4 (0=dark/hard, 4=bright/great)
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DailyNoteEntityCopyWith<DailyNoteEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyNoteEntityCopyWith<$Res> {
  factory $DailyNoteEntityCopyWith(
          DailyNoteEntity value, $Res Function(DailyNoteEntity) then) =
      _$DailyNoteEntityCopyWithImpl<$Res, DailyNoteEntity>;
  @useResult
  $Res call(
      {String id,
      String date,
      String? text,
      String? photoPath,
      int? mood,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$DailyNoteEntityCopyWithImpl<$Res, $Val extends DailyNoteEntity>
    implements $DailyNoteEntityCopyWith<$Res> {
  _$DailyNoteEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? text = freezed,
    Object? photoPath = freezed,
    Object? mood = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      mood: freezed == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$DailyNoteEntityImplCopyWith<$Res>
    implements $DailyNoteEntityCopyWith<$Res> {
  factory _$$DailyNoteEntityImplCopyWith(_$DailyNoteEntityImpl value,
          $Res Function(_$DailyNoteEntityImpl) then) =
      __$$DailyNoteEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String date,
      String? text,
      String? photoPath,
      int? mood,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$DailyNoteEntityImplCopyWithImpl<$Res>
    extends _$DailyNoteEntityCopyWithImpl<$Res, _$DailyNoteEntityImpl>
    implements _$$DailyNoteEntityImplCopyWith<$Res> {
  __$$DailyNoteEntityImplCopyWithImpl(
      _$DailyNoteEntityImpl _value, $Res Function(_$DailyNoteEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? text = freezed,
    Object? photoPath = freezed,
    Object? mood = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$DailyNoteEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      mood: freezed == mood
          ? _value.mood
          : mood // ignore: cast_nullable_to_non_nullable
              as int?,
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

class _$DailyNoteEntityImpl implements _DailyNoteEntity {
  const _$DailyNoteEntityImpl(
      {required this.id,
      required this.date,
      this.text,
      this.photoPath,
      this.mood,
      required this.createdAt,
      required this.updatedAt});

  @override
  final String id;
  @override
  final String date;
// "yyyy-MM-dd", unique per day
  @override
  final String? text;
// max 200 chars
  @override
  final String? photoPath;
// local file path, Pro only
  @override
  final int? mood;
// 0–4 (0=dark/hard, 4=bright/great)
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'DailyNoteEntity(id: $id, date: $date, text: $text, photoPath: $photoPath, mood: $mood, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyNoteEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, date, text, photoPath, mood, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyNoteEntityImplCopyWith<_$DailyNoteEntityImpl> get copyWith =>
      __$$DailyNoteEntityImplCopyWithImpl<_$DailyNoteEntityImpl>(
          this, _$identity);
}

abstract class _DailyNoteEntity implements DailyNoteEntity {
  const factory _DailyNoteEntity(
      {required final String id,
      required final String date,
      final String? text,
      final String? photoPath,
      final int? mood,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$DailyNoteEntityImpl;

  @override
  String get id;
  @override
  String get date;
  @override // "yyyy-MM-dd", unique per day
  String? get text;
  @override // max 200 chars
  String? get photoPath;
  @override // local file path, Pro only
  int? get mood;
  @override // 0–4 (0=dark/hard, 4=bright/great)
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$DailyNoteEntityImplCopyWith<_$DailyNoteEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
