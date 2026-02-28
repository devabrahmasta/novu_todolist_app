// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:novu_todolist_app/core/di/register_module.dart' as _i26;
import 'package:novu_todolist_app/core/utils/settings_service.dart' as _i24;
import 'package:novu_todolist_app/features/category/data/datasources/category_local_data_source.dart'
    as _i10;
import 'package:novu_todolist_app/features/category/data/repositories/category_repository_impl.dart'
    as _i12;
import 'package:novu_todolist_app/features/category/domain/repositories/category_repository.dart'
    as _i11;
import 'package:novu_todolist_app/features/category/domain/usecases/create_category_usecase.dart'
    as _i14;
import 'package:novu_todolist_app/features/category/domain/usecases/delete_category_usecase.dart'
    as _i16;
import 'package:novu_todolist_app/features/category/domain/usecases/get_all_categories_usecase.dart'
    as _i18;
import 'package:novu_todolist_app/features/category/domain/usecases/update_category_usecase.dart'
    as _i25;
import 'package:novu_todolist_app/features/task/data/datasources/task_local_data_source.dart'
    as _i5;
import 'package:novu_todolist_app/features/task/data/repositories/task_repository_impl.dart'
    as _i7;
import 'package:novu_todolist_app/features/task/domain/repositories/task_repository.dart'
    as _i6;
import 'package:novu_todolist_app/features/task/domain/usecases/archive_task_usecase.dart'
    as _i9;
import 'package:novu_todolist_app/features/task/domain/usecases/complete_task_usecase.dart'
    as _i13;
import 'package:novu_todolist_app/features/task/domain/usecases/create_task_usecase.dart'
    as _i15;
import 'package:novu_todolist_app/features/task/domain/usecases/delete_task_usecase.dart'
    as _i17;
import 'package:novu_todolist_app/features/task/domain/usecases/get_all_tasks_usecase.dart'
    as _i19;
import 'package:novu_todolist_app/features/task/domain/usecases/get_task_analytics_usecase.dart'
    as _i20;
import 'package:novu_todolist_app/features/task/domain/usecases/get_task_by_id_usecase.dart'
    as _i21;
import 'package:novu_todolist_app/features/task/domain/usecases/get_tasks_by_date_usecase.dart'
    as _i22;
import 'package:novu_todolist_app/features/task/domain/usecases/get_tasks_by_time_slot_usecase.dart'
    as _i23;
import 'package:novu_todolist_app/features/task/domain/usecases/update_task_usecase.dart'
    as _i8;
import 'package:shared_preferences/shared_preferences.dart' as _i4;
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
    await gh.lazySingletonAsync<_i4.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i5.TaskLocalDataSource>(
        () => _i5.TaskLocalDataSource(gh<_i3.Database>()));
    gh.lazySingleton<_i6.TaskRepository>(
        () => _i7.TaskRepositoryImpl(gh<_i5.TaskLocalDataSource>()));
    gh.lazySingleton<_i8.UpdateTaskUsecase>(
        () => _i8.UpdateTaskUsecase(gh<_i6.TaskRepository>()));
    gh.lazySingleton<_i9.ArchiveTaskUsecase>(
        () => _i9.ArchiveTaskUsecase(gh<_i6.TaskRepository>()));
    gh.lazySingleton<_i10.CategoryLocalDataSource>(
        () => _i10.CategoryLocalDataSource(gh<_i3.Database>()));
    gh.lazySingleton<_i11.CategoryRepository>(
        () => _i12.CategoryRepositoryImpl(gh<_i10.CategoryLocalDataSource>()));
    gh.lazySingleton<_i13.CompleteTaskUsecase>(
        () => _i13.CompleteTaskUsecase(gh<_i6.TaskRepository>()));
    gh.lazySingleton<_i14.CreateCategoryUsecase>(
        () => _i14.CreateCategoryUsecase(gh<_i11.CategoryRepository>()));
    gh.lazySingleton<_i15.CreateTaskUsecase>(
        () => _i15.CreateTaskUsecase(gh<_i6.TaskRepository>()));
    gh.lazySingleton<_i16.DeleteCategoryUsecase>(
        () => _i16.DeleteCategoryUsecase(gh<_i11.CategoryRepository>()));
    gh.lazySingleton<_i17.DeleteTaskUsecase>(
        () => _i17.DeleteTaskUsecase(gh<_i6.TaskRepository>()));
    gh.lazySingleton<_i18.GetAllCategoriesUsecase>(
        () => _i18.GetAllCategoriesUsecase(gh<_i11.CategoryRepository>()));
    gh.lazySingleton<_i19.GetAllTasksUsecase>(
        () => _i19.GetAllTasksUsecase(gh<_i6.TaskRepository>()));
    gh.lazySingleton<_i20.GetTaskAnalyticsUsecase>(
        () => _i20.GetTaskAnalyticsUsecase(gh<_i6.TaskRepository>()));
    gh.lazySingleton<_i21.GetTaskByIdUsecase>(
        () => _i21.GetTaskByIdUsecase(gh<_i6.TaskRepository>()));
    gh.lazySingleton<_i22.GetTasksByDateUsecase>(
        () => _i22.GetTasksByDateUsecase(gh<_i6.TaskRepository>()));
    gh.lazySingleton<_i23.GetTasksByTimeSlotUsecase>(
        () => _i23.GetTasksByTimeSlotUsecase(gh<_i6.TaskRepository>()));
    gh.lazySingleton<_i24.SettingsService>(
        () => _i24.SettingsService(gh<_i4.SharedPreferences>()));
    gh.lazySingleton<_i25.UpdateCategoryUsecase>(
        () => _i25.UpdateCategoryUsecase(gh<_i11.CategoryRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i26.RegisterModule {}
