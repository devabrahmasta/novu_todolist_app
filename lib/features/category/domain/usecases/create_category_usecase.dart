import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Creates a new category.
@lazySingleton
class CreateCategoryUsecase {
  final CategoryRepository _repository;
  CreateCategoryUsecase(this._repository);

  Future<Either<Failure, Unit>> call(CategoryEntity category) {
    return _repository.createCategory(category);
  }
}
