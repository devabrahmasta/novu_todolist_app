// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:novu_todolist_app/core/di/register_module.dart' as _i45;
import 'package:novu_todolist_app/core/utils/settings_service.dart' as _i42;
import 'package:novu_todolist_app/features/category/data/datasources/category_local_data_source.dart'
    as _i16;
import 'package:novu_todolist_app/features/category/data/repositories/category_repository_impl.dart'
    as _i18;
import 'package:novu_todolist_app/features/category/domain/repositories/category_repository.dart'
    as _i17;
import 'package:novu_todolist_app/features/category/domain/usecases/create_category_usecase.dart'
    as _i20;
import 'package:novu_todolist_app/features/category/domain/usecases/delete_category_usecase.dart'
    as _i27;
import 'package:novu_todolist_app/features/category/domain/usecases/get_all_categories_usecase.dart'
    as _i31;
import 'package:novu_todolist_app/features/category/domain/usecases/update_category_usecase.dart'
    as _i43;
import 'package:novu_todolist_app/features/daily_note/data/datasources/daily_note_local_data_source.dart'
    as _i24;
import 'package:novu_todolist_app/features/daily_note/data/repositories/daily_note_repository_impl.dart'
    as _i26;
import 'package:novu_todolist_app/features/daily_note/domain/repositories/daily_note_repository.dart'
    as _i25;
import 'package:novu_todolist_app/features/daily_note/domain/usecases/get_all_daily_notes_usecase.dart'
    as _i32;
import 'package:novu_todolist_app/features/daily_note/domain/usecases/get_daily_note_usecase.dart'
    as _i35;
import 'package:novu_todolist_app/features/daily_note/domain/usecases/upsert_daily_note_usecase.dart'
    as _i44;
import 'package:novu_todolist_app/features/habit/data/datasources/habit_local_data_source.dart'
    as _i4;
import 'package:novu_todolist_app/features/habit/data/repositories/habit_repository_impl.dart'
    as _i6;
import 'package:novu_todolist_app/features/habit/domain/repositories/habit_repository.dart'
    as _i5;
import 'package:novu_todolist_app/features/habit/domain/usecases/create_habit_goal_usecase.dart'
    as _i21;
import 'package:novu_todolist_app/features/habit/domain/usecases/create_habit_usecase.dart'
    as _i22;
import 'package:novu_todolist_app/features/habit/domain/usecases/delete_habit_usecase.dart'
    as _i28;
import 'package:novu_todolist_app/features/habit/domain/usecases/get_active_goal_usecase.dart'
    as _i30;
import 'package:novu_todolist_app/features/habit/domain/usecases/get_all_habits_usecase.dart'
    as _i33;
import 'package:novu_todolist_app/features/habit/domain/usecases/get_habit_by_id_usecase.dart'
    as _i36;
import 'package:novu_todolist_app/features/habit/domain/usecases/get_habit_completions_usecase.dart'
    as _i37;
import 'package:novu_todolist_app/features/habit/domain/usecases/log_habit_completion_usecase.dart'
    as _i7;
import 'package:novu_todolist_app/features/habit/domain/usecases/update_habit_goal_usecase.dart'
    as _i12;
import 'package:novu_todolist_app/features/habit/domain/usecases/update_habit_usecase.dart'
    as _i13;
import 'package:novu_todolist_app/features/task/data/datasources/task_local_data_source.dart'
    as _i9;
import 'package:novu_todolist_app/features/task/data/repositories/task_repository_impl.dart'
    as _i11;
import 'package:novu_todolist_app/features/task/domain/repositories/task_repository.dart'
    as _i10;
import 'package:novu_todolist_app/features/task/domain/usecases/archive_task_usecase.dart'
    as _i15;
import 'package:novu_todolist_app/features/task/domain/usecases/complete_task_usecase.dart'
    as _i19;
import 'package:novu_todolist_app/features/task/domain/usecases/create_task_usecase.dart'
    as _i23;
import 'package:novu_todolist_app/features/task/domain/usecases/delete_task_usecase.dart'
    as _i29;
import 'package:novu_todolist_app/features/task/domain/usecases/get_all_tasks_usecase.dart'
    as _i34;
import 'package:novu_todolist_app/features/task/domain/usecases/get_task_analytics_usecase.dart'
    as _i38;
import 'package:novu_todolist_app/features/task/domain/usecases/get_task_by_id_usecase.dart'
    as _i39;
import 'package:novu_todolist_app/features/task/domain/usecases/get_tasks_by_date_usecase.dart'
    as _i40;
import 'package:novu_todolist_app/features/task/domain/usecases/get_tasks_by_time_slot_usecase.dart'
    as _i41;
import 'package:novu_todolist_app/features/task/domain/usecases/update_task_usecase.dart'
    as _i14;
import 'package:shared_preferences/shared_preferences.dart' as _i8;
import 'package:sqflite/sqflite.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.lazySingletonAsync<_i3.Database>(
      () => registerModule.database,
      preResolve: true,
    );
    gh.lazySingleton<_i4.HabitLocalDataSource>(
        () => _i4.HabitLocalDataSource(gh<_i3.Database>()));
    gh.lazySingleton<_i5.HabitRepository>(
        () => _i6.HabitRepositoryImpl(gh<_i4.HabitLocalDataSource>()));
    gh.lazySingleton<_i7.LogHabitCompletionUsecase>(
        () => _i7.LogHabitCompletionUsecase(gh<_i5.HabitRepository>()));
    await gh.lazySingletonAsync<_i8.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i9.TaskLocalDataSource>(
        () => _i9.TaskLocalDataSource(gh<_i3.Database>()));
    gh.lazySingleton<_i10.TaskRepository>(
        () => _i11.TaskRepositoryImpl(gh<_i9.TaskLocalDataSource>()));
    gh.lazySingleton<_i12.UpdateHabitGoalUsecase>(
        () => _i12.UpdateHabitGoalUsecase(gh<_i5.HabitRepository>()));
    gh.lazySingleton<_i13.UpdateHabitUsecase>(
        () => _i13.UpdateHabitUsecase(gh<_i5.HabitRepository>()));
    gh.lazySingleton<_i14.UpdateTaskUsecase>(
        () => _i14.UpdateTaskUsecase(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i15.ArchiveTaskUsecase>(
        () => _i15.ArchiveTaskUsecase(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i16.CategoryLocalDataSource>(
        () => _i16.CategoryLocalDataSource(gh<_i3.Database>()));
    gh.lazySingleton<_i17.CategoryRepository>(
        () => _i18.CategoryRepositoryImpl(gh<_i16.CategoryLocalDataSource>()));
    gh.lazySingleton<_i19.CompleteTaskUsecase>(
        () => _i19.CompleteTaskUsecase(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i20.CreateCategoryUsecase>(
        () => _i20.CreateCategoryUsecase(gh<_i17.CategoryRepository>()));
    gh.lazySingleton<_i21.CreateHabitGoalUsecase>(
        () => _i21.CreateHabitGoalUsecase(gh<_i5.HabitRepository>()));
    gh.lazySingleton<_i22.CreateHabitUsecase>(
        () => _i22.CreateHabitUsecase(gh<_i5.HabitRepository>()));
    gh.lazySingleton<_i23.CreateTaskUsecase>(
        () => _i23.CreateTaskUsecase(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i24.DailyNoteLocalDataSource>(
        () => _i24.DailyNoteLocalDataSource(gh<_i3.Database>()));
    gh.lazySingleton<_i25.DailyNoteRepository>(() =>
        _i26.DailyNoteRepositoryImpl(gh<_i24.DailyNoteLocalDataSource>()));
    gh.lazySingleton<_i27.DeleteCategoryUsecase>(
        () => _i27.DeleteCategoryUsecase(gh<_i17.CategoryRepository>()));
    gh.lazySingleton<_i28.DeleteHabitUsecase>(
        () => _i28.DeleteHabitUsecase(gh<_i5.HabitRepository>()));
    gh.lazySingleton<_i29.DeleteTaskUsecase>(
        () => _i29.DeleteTaskUsecase(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i30.GetActiveGoalUsecase>(
        () => _i30.GetActiveGoalUsecase(gh<_i5.HabitRepository>()));
    gh.lazySingleton<_i31.GetAllCategoriesUsecase>(
        () => _i31.GetAllCategoriesUsecase(gh<_i17.CategoryRepository>()));
    gh.lazySingleton<_i32.GetAllDailyNotesUsecase>(
        () => _i32.GetAllDailyNotesUsecase(gh<_i25.DailyNoteRepository>()));
    gh.lazySingleton<_i33.GetAllHabitsUsecase>(
        () => _i33.GetAllHabitsUsecase(gh<_i5.HabitRepository>()));
    gh.lazySingleton<_i34.GetAllTasksUsecase>(
        () => _i34.GetAllTasksUsecase(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i35.GetDailyNoteUsecase>(
        () => _i35.GetDailyNoteUsecase(gh<_i25.DailyNoteRepository>()));
    gh.lazySingleton<_i36.GetHabitByIdUsecase>(
        () => _i36.GetHabitByIdUsecase(gh<_i5.HabitRepository>()));
    gh.lazySingleton<_i37.GetHabitCompletionsUsecase>(
        () => _i37.GetHabitCompletionsUsecase(gh<_i5.HabitRepository>()));
    gh.lazySingleton<_i38.GetTaskAnalyticsUsecase>(
        () => _i38.GetTaskAnalyticsUsecase(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i39.GetTaskByIdUsecase>(
        () => _i39.GetTaskByIdUsecase(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i40.GetTasksByDateUsecase>(
        () => _i40.GetTasksByDateUsecase(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i41.GetTasksByTimeSlotUsecase>(
        () => _i41.GetTasksByTimeSlotUsecase(gh<_i10.TaskRepository>()));
    gh.lazySingleton<_i42.SettingsService>(
        () => _i42.SettingsService(gh<_i8.SharedPreferences>()));
    gh.lazySingleton<_i43.UpdateCategoryUsecase>(
        () => _i43.UpdateCategoryUsecase(gh<_i17.CategoryRepository>()));
    gh.lazySingleton<_i44.UpsertDailyNoteUsecase>(
        () => _i44.UpsertDailyNoteUsecase(gh<_i25.DailyNoteRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i45.RegisterModule {}
