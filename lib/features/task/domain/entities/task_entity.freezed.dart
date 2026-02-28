// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TaskEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  TimeOfDaySlot get timeOfDay => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError;
  TimeOfDay? get dueTime => throw _privateConstructorUsedError;
  TaskPriority? get priority =>
      throw _privateConstructorUsedError; // always optional
  TaskStatus get status => throw _privateConstructorUsedError;
  List<SubtaskEntity> get subtasks => throw _privateConstructorUsedError;
  ReminderConfig? get reminder => throw _privateConstructorUsedError;
  RepeatConfig? get repeat => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  int get streak => throw _privateConstructorUsedError;
  int get totalCompletions => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TaskEntityCopyWith<TaskEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskEntityCopyWith<$Res> {
  factory $TaskEntityCopyWith(
          TaskEntity value, $Res Function(TaskEntity) then) =
      _$TaskEntityCopyWithImpl<$Res, TaskEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String? categoryId,
      TimeOfDaySlot timeOfDay,
      DateTime? dueDate,
      TimeOfDay? dueTime,
      TaskPriority? priority,
      TaskStatus status,
      List<SubtaskEntity> subtasks,
      ReminderConfig? reminder,
      RepeatConfig? repeat,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? completedAt,
      int streak,
      int totalCompletions});

  $ReminderConfigCopyWith<$Res>? get reminder;
  $RepeatConfigCopyWith<$Res>? get repeat;
}

/// @nodoc
class _$TaskEntityCopyWithImpl<$Res, $Val extends TaskEntity>
    implements $TaskEntityCopyWith<$Res> {
  _$TaskEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? categoryId = freezed,
    Object? timeOfDay = null,
    Object? dueDate = freezed,
    Object? dueTime = freezed,
    Object? priority = freezed,
    Object? status = null,
    Object? subtasks = null,
    Object? reminder = freezed,
    Object? repeat = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
    Object? streak = null,
    Object? totalCompletions = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      timeOfDay: null == timeOfDay
          ? _value.timeOfDay
          : timeOfDay // ignore: cast_nullable_to_non_nullable
              as TimeOfDaySlot,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueTime: freezed == dueTime
          ? _value.dueTime
          : dueTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      subtasks: null == subtasks
          ? _value.subtasks
          : subtasks // ignore: cast_nullable_to_non_nullable
              as List<SubtaskEntity>,
      reminder: freezed == reminder
          ? _value.reminder
          : reminder // ignore: cast_nullable_to_non_nullable
              as ReminderConfig?,
      repeat: freezed == repeat
          ? _value.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as RepeatConfig?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      totalCompletions: null == totalCompletions
          ? _value.totalCompletions
          : totalCompletions // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReminderConfigCopyWith<$Res>? get reminder {
    if (_value.reminder == null) {
      return null;
    }

    return $ReminderConfigCopyWith<$Res>(_value.reminder!, (value) {
      return _then(_value.copyWith(reminder: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RepeatConfigCopyWith<$Res>? get repeat {
    if (_value.repeat == null) {
      return null;
    }

    return $RepeatConfigCopyWith<$Res>(_value.repeat!, (value) {
      return _then(_value.copyWith(repeat: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskEntityImplCopyWith<$Res>
    implements $TaskEntityCopyWith<$Res> {
  factory _$$TaskEntityImplCopyWith(
          _$TaskEntityImpl value, $Res Function(_$TaskEntityImpl) then) =
      __$$TaskEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String? categoryId,
      TimeOfDaySlot timeOfDay,
      DateTime? dueDate,
      TimeOfDay? dueTime,
      TaskPriority? priority,
      TaskStatus status,
      List<SubtaskEntity> subtasks,
      ReminderConfig? reminder,
      RepeatConfig? repeat,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? completedAt,
      int streak,
      int totalCompletions});

  @override
  $ReminderConfigCopyWith<$Res>? get reminder;
  @override
  $RepeatConfigCopyWith<$Res>? get repeat;
}

/// @nodoc
class __$$TaskEntityImplCopyWithImpl<$Res>
    extends _$TaskEntityCopyWithImpl<$Res, _$TaskEntityImpl>
    implements _$$TaskEntityImplCopyWith<$Res> {
  __$$TaskEntityImplCopyWithImpl(
      _$TaskEntityImpl _value, $Res Function(_$TaskEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? categoryId = freezed,
    Object? timeOfDay = null,
    Object? dueDate = freezed,
    Object? dueTime = freezed,
    Object? priority = freezed,
    Object? status = null,
    Object? subtasks = null,
    Object? reminder = freezed,
    Object? repeat = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
    Object? streak = null,
    Object? totalCompletions = null,
  }) {
    return _then(_$TaskEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      timeOfDay: null == timeOfDay
          ? _value.timeOfDay
          : timeOfDay // ignore: cast_nullable_to_non_nullable
              as TimeOfDaySlot,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueTime: freezed == dueTime
          ? _value.dueTime
          : dueTime // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      subtasks: null == subtasks
          ? _value._subtasks
          : subtasks // ignore: cast_nullable_to_non_nullable
              as List<SubtaskEntity>,
      reminder: freezed == reminder
          ? _value.reminder
          : reminder // ignore: cast_nullable_to_non_nullable
              as ReminderConfig?,
      repeat: freezed == repeat
          ? _value.repeat
          : repeat // ignore: cast_nullable_to_non_nullable
              as RepeatConfig?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      totalCompletions: null == totalCompletions
          ? _value.totalCompletions
          : totalCompletions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TaskEntityImpl implements _TaskEntity {
  const _$TaskEntityImpl(
      {required this.id,
      required this.title,
      this.description,
      this.categoryId,
      required this.timeOfDay,
      this.dueDate,
      this.dueTime,
      this.priority,
      required this.status,
      final List<SubtaskEntity> subtasks = const [],
      this.reminder,
      this.repeat,
      required this.createdAt,
      required this.updatedAt,
      this.completedAt,
      this.streak = 0,
      this.totalCompletions = 0})
      : _subtasks = subtasks;

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? categoryId;
  @override
  final TimeOfDaySlot timeOfDay;
  @override
  final DateTime? dueDate;
  @override
  final TimeOfDay? dueTime;
  @override
  final TaskPriority? priority;
// always optional
  @override
  final TaskStatus status;
  final List<SubtaskEntity> _subtasks;
  @override
  @JsonKey()
  List<SubtaskEntity> get subtasks {
    if (_subtasks is EqualUnmodifiableListView) return _subtasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subtasks);
  }

  @override
  final ReminderConfig? reminder;
  @override
  final RepeatConfig? repeat;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? completedAt;
  @override
  @JsonKey()
  final int streak;
  @override
  @JsonKey()
  final int totalCompletions;

  @override
  String toString() {
    return 'TaskEntity(id: $id, title: $title, description: $description, categoryId: $categoryId, timeOfDay: $timeOfDay, dueDate: $dueDate, dueTime: $dueTime, priority: $priority, status: $status, subtasks: $subtasks, reminder: $reminder, repeat: $repeat, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, streak: $streak, totalCompletions: $totalCompletions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.timeOfDay, timeOfDay) ||
                other.timeOfDay == timeOfDay) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.dueTime, dueTime) || other.dueTime == dueTime) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._subtasks, _subtasks) &&
            (identical(other.reminder, reminder) ||
                other.reminder == reminder) &&
            (identical(other.repeat, repeat) || other.repeat == repeat) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.totalCompletions, totalCompletions) ||
                other.totalCompletions == totalCompletions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      categoryId,
      timeOfDay,
      dueDate,
      dueTime,
      priority,
      status,
      const DeepCollectionEquality().hash(_subtasks),
      reminder,
      repeat,
      createdAt,
      updatedAt,
      completedAt,
      streak,
      totalCompletions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskEntityImplCopyWith<_$TaskEntityImpl> get copyWith =>
      __$$TaskEntityImplCopyWithImpl<_$TaskEntityImpl>(this, _$identity);
}

abstract class _TaskEntity implements TaskEntity {
  const factory _TaskEntity(
      {required final String id,
      required final String title,
      final String? description,
      final String? categoryId,
      required final TimeOfDaySlot timeOfDay,
      final DateTime? dueDate,
      final TimeOfDay? dueTime,
      final TaskPriority? priority,
      required final TaskStatus status,
      final List<SubtaskEntity> subtasks,
      final ReminderConfig? reminder,
      final RepeatConfig? repeat,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? completedAt,
      final int streak,
      final int totalCompletions}) = _$TaskEntityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get categoryId;
  @override
  TimeOfDaySlot get timeOfDay;
  @override
  DateTime? get dueDate;
  @override
  TimeOfDay? get dueTime;
  @override
  TaskPriority? get priority;
  @override // always optional
  TaskStatus get status;
  @override
  List<SubtaskEntity> get subtasks;
  @override
  ReminderConfig? get reminder;
  @override
  RepeatConfig? get repeat;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get completedAt;
  @override
  int get streak;
  @override
  int get totalCompletions;
  @override
  @JsonKey(ignore: true)
  _$$TaskEntityImplCopyWith<_$TaskEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SubtaskEntity {
  String get id => throw _privateConstructorUsedError;
  String get taskId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubtaskEntityCopyWith<SubtaskEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubtaskEntityCopyWith<$Res> {
  factory $SubtaskEntityCopyWith(
          SubtaskEntity value, $Res Function(SubtaskEntity) then) =
      _$SubtaskEntityCopyWithImpl<$Res, SubtaskEntity>;
  @useResult
  $Res call(
      {String id, String taskId, String title, bool isCompleted, int order});
}

/// @nodoc
class _$SubtaskEntityCopyWithImpl<$Res, $Val extends SubtaskEntity>
    implements $SubtaskEntityCopyWith<$Res> {
  _$SubtaskEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubtaskEntityImplCopyWith<$Res>
    implements $SubtaskEntityCopyWith<$Res> {
  factory _$$SubtaskEntityImplCopyWith(
          _$SubtaskEntityImpl value, $Res Function(_$SubtaskEntityImpl) then) =
      __$$SubtaskEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String taskId, String title, bool isCompleted, int order});
}

/// @nodoc
class __$$SubtaskEntityImplCopyWithImpl<$Res>
    extends _$SubtaskEntityCopyWithImpl<$Res, _$SubtaskEntityImpl>
    implements _$$SubtaskEntityImplCopyWith<$Res> {
  __$$SubtaskEntityImplCopyWithImpl(
      _$SubtaskEntityImpl _value, $Res Function(_$SubtaskEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? title = null,
    Object? isCompleted = null,
    Object? order = null,
  }) {
    return _then(_$SubtaskEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SubtaskEntityImpl implements _SubtaskEntity {
  const _$SubtaskEntityImpl(
      {required this.id,
      required this.taskId,
      required this.title,
      this.isCompleted = false,
      required this.order});

  @override
  final String id;
  @override
  final String taskId;
  @override
  final String title;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final int order;

  @override
  String toString() {
    return 'SubtaskEntity(id: $id, taskId: $taskId, title: $title, isCompleted: $isCompleted, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubtaskEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, taskId, title, isCompleted, order);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubtaskEntityImplCopyWith<_$SubtaskEntityImpl> get copyWith =>
      __$$SubtaskEntityImplCopyWithImpl<_$SubtaskEntityImpl>(this, _$identity);
}

abstract class _SubtaskEntity implements SubtaskEntity {
  const factory _SubtaskEntity(
      {required final String id,
      required final String taskId,
      required final String title,
      final bool isCompleted,
      required final int order}) = _$SubtaskEntityImpl;

  @override
  String get id;
  @override
  String get taskId;
  @override
  String get title;
  @override
  bool get isCompleted;
  @override
  int get order;
  @override
  @JsonKey(ignore: true)
  _$$SubtaskEntityImplCopyWith<_$SubtaskEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReminderConfig {
  bool get isEnabled => throw _privateConstructorUsedError;
  int get offsetMinutes => throw _privateConstructorUsedError;
  DateTime? get customTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReminderConfigCopyWith<ReminderConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderConfigCopyWith<$Res> {
  factory $ReminderConfigCopyWith(
          ReminderConfig value, $Res Function(ReminderConfig) then) =
      _$ReminderConfigCopyWithImpl<$Res, ReminderConfig>;
  @useResult
  $Res call({bool isEnabled, int offsetMinutes, DateTime? customTime});
}

/// @nodoc
class _$ReminderConfigCopyWithImpl<$Res, $Val extends ReminderConfig>
    implements $ReminderConfigCopyWith<$Res> {
  _$ReminderConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? offsetMinutes = null,
    Object? customTime = freezed,
  }) {
    return _then(_value.copyWith(
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      offsetMinutes: null == offsetMinutes
          ? _value.offsetMinutes
          : offsetMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      customTime: freezed == customTime
          ? _value.customTime
          : customTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReminderConfigImplCopyWith<$Res>
    implements $ReminderConfigCopyWith<$Res> {
  factory _$$ReminderConfigImplCopyWith(_$ReminderConfigImpl value,
          $Res Function(_$ReminderConfigImpl) then) =
      __$$ReminderConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isEnabled, int offsetMinutes, DateTime? customTime});
}

/// @nodoc
class __$$ReminderConfigImplCopyWithImpl<$Res>
    extends _$ReminderConfigCopyWithImpl<$Res, _$ReminderConfigImpl>
    implements _$$ReminderConfigImplCopyWith<$Res> {
  __$$ReminderConfigImplCopyWithImpl(
      _$ReminderConfigImpl _value, $Res Function(_$ReminderConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEnabled = null,
    Object? offsetMinutes = null,
    Object? customTime = freezed,
  }) {
    return _then(_$ReminderConfigImpl(
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      offsetMinutes: null == offsetMinutes
          ? _value.offsetMinutes
          : offsetMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      customTime: freezed == customTime
          ? _value.customTime
          : customTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ReminderConfigImpl implements _ReminderConfig {
  const _$ReminderConfigImpl(
      {this.isEnabled = false, this.offsetMinutes = 15, this.customTime});

  @override
  @JsonKey()
  final bool isEnabled;
  @override
  @JsonKey()
  final int offsetMinutes;
  @override
  final DateTime? customTime;

  @override
  String toString() {
    return 'ReminderConfig(isEnabled: $isEnabled, offsetMinutes: $offsetMinutes, customTime: $customTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderConfigImpl &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.offsetMinutes, offsetMinutes) ||
                other.offsetMinutes == offsetMinutes) &&
            (identical(other.customTime, customTime) ||
                other.customTime == customTime));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isEnabled, offsetMinutes, customTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderConfigImplCopyWith<_$ReminderConfigImpl> get copyWith =>
      __$$ReminderConfigImplCopyWithImpl<_$ReminderConfigImpl>(
          this, _$identity);
}

abstract class _ReminderConfig implements ReminderConfig {
  const factory _ReminderConfig(
      {final bool isEnabled,
      final int offsetMinutes,
      final DateTime? customTime}) = _$ReminderConfigImpl;

  @override
  bool get isEnabled;
  @override
  int get offsetMinutes;
  @override
  DateTime? get customTime;
  @override
  @JsonKey(ignore: true)
  _$$ReminderConfigImplCopyWith<_$ReminderConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RepeatConfig {
  RepeatType get type => throw _privateConstructorUsedError;
  List<int>? get customDays => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RepeatConfigCopyWith<RepeatConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepeatConfigCopyWith<$Res> {
  factory $RepeatConfigCopyWith(
          RepeatConfig value, $Res Function(RepeatConfig) then) =
      _$RepeatConfigCopyWithImpl<$Res, RepeatConfig>;
  @useResult
  $Res call({RepeatType type, List<int>? customDays});
}

/// @nodoc
class _$RepeatConfigCopyWithImpl<$Res, $Val extends RepeatConfig>
    implements $RepeatConfigCopyWith<$Res> {
  _$RepeatConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? customDays = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RepeatType,
      customDays: freezed == customDays
          ? _value.customDays
          : customDays // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RepeatConfigImplCopyWith<$Res>
    implements $RepeatConfigCopyWith<$Res> {
  factory _$$RepeatConfigImplCopyWith(
          _$RepeatConfigImpl value, $Res Function(_$RepeatConfigImpl) then) =
      __$$RepeatConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RepeatType type, List<int>? customDays});
}

/// @nodoc
class __$$RepeatConfigImplCopyWithImpl<$Res>
    extends _$RepeatConfigCopyWithImpl<$Res, _$RepeatConfigImpl>
    implements _$$RepeatConfigImplCopyWith<$Res> {
  __$$RepeatConfigImplCopyWithImpl(
      _$RepeatConfigImpl _value, $Res Function(_$RepeatConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? customDays = freezed,
  }) {
    return _then(_$RepeatConfigImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RepeatType,
      customDays: freezed == customDays
          ? _value._customDays
          : customDays // ignore: cast_nullable_to_non_nullable
              as List<int>?,
    ));
  }
}

/// @nodoc

class _$RepeatConfigImpl implements _RepeatConfig {
  const _$RepeatConfigImpl(
      {this.type = RepeatType.none, final List<int>? customDays})
      : _customDays = customDays;

  @override
  @JsonKey()
  final RepeatType type;
  final List<int>? _customDays;
  @override
  List<int>? get customDays {
    final value = _customDays;
    if (value == null) return null;
    if (_customDays is EqualUnmodifiableListView) return _customDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RepeatConfig(type: $type, customDays: $customDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepeatConfigImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._customDays, _customDays));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, type, const DeepCollectionEquality().hash(_customDays));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RepeatConfigImplCopyWith<_$RepeatConfigImpl> get copyWith =>
      __$$RepeatConfigImplCopyWithImpl<_$RepeatConfigImpl>(this, _$identity);
}

abstract class _RepeatConfig implements RepeatConfig {
  const factory _RepeatConfig(
      {final RepeatType type,
      final List<int>? customDays}) = _$RepeatConfigImpl;

  @override
  RepeatType get type;
  @override
  List<int>? get customDays;
  @override
  @JsonKey(ignore: true)
  _$$RepeatConfigImplCopyWith<_$RepeatConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
