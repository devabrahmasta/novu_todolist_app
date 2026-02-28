import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';

/// Abstract category repository — domain layer contract.
abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, Unit>> createCategory(CategoryEntity category);
  Future<Either<Failure, Unit>> updateCategory(CategoryEntity category);
  Future<Either<Failure, Unit>> deleteCategory(String id);
}
