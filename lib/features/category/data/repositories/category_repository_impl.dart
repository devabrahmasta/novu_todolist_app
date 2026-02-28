import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../models/category_model.dart';

/// Concrete implementation of [CategoryRepository] backed by Isar.
@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource _localDataSource;

  CategoryRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final models = await _localDataSource.getAllCategories();
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return left(CacheFailure('Failed to get categories: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> createCategory(CategoryEntity category) async {
    try {
      await _localDataSource.putCategory(category.toModel());
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to create category: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCategory(CategoryEntity category) async {
    try {
      await _localDataSource.putCategory(category.toModel());
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to update category: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    try {
      await _localDataSource.deleteCategory(id);
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to delete category: $e'));
    }
  }
}
