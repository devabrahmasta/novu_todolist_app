import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/category_repository.dart';

/// Deletes a category by ID.
@lazySingleton
class DeleteCategoryUsecase {
  final CategoryRepository _repository;
  DeleteCategoryUsecase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deleteCategory(id);
  }
}
