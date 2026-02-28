import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Returns all categories.
@lazySingleton
class GetAllCategoriesUsecase {
  final CategoryRepository _repository;
  GetAllCategoriesUsecase(this._repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return _repository.getAllCategories();
  }
}
