import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Updates an existing category.
@lazySingleton
class UpdateCategoryUsecase {
  final CategoryRepository _repository;
  UpdateCategoryUsecase(this._repository);

  Future<Either<Failure, Unit>> call(CategoryEntity category) {
    return _repository.updateCategory(category);
  }
}
