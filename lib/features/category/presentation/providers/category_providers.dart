import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/create_category_usecase.dart';
import '../../domain/usecases/delete_category_usecase.dart';
import '../../domain/usecases/get_all_categories_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';

part 'category_providers.g.dart';

// ─── Use case providers ─────────────────────────────────

@riverpod
GetAllCategoriesUsecase getAllCategoriesUsecase(
  GetAllCategoriesUsecaseRef ref,
) => getIt<GetAllCategoriesUsecase>();

@riverpod
CreateCategoryUsecase createCategoryUsecase(CreateCategoryUsecaseRef ref) =>
    getIt<CreateCategoryUsecase>();

@riverpod
UpdateCategoryUsecase updateCategoryUsecase(UpdateCategoryUsecaseRef ref) =>
    getIt<UpdateCategoryUsecase>();

@riverpod
DeleteCategoryUsecase deleteCategoryUsecase(DeleteCategoryUsecaseRef ref) =>
    getIt<DeleteCategoryUsecase>();

// ─── Category list notifier ─────────────────────────────

@riverpod
class CategoryListNotifier extends _$CategoryListNotifier {
  @override
  Future<List<CategoryEntity>> build() async {
    final result = await ref.watch(getAllCategoriesUsecaseProvider).call();
    return result.getOrElse((_) => []);
  }

  Future<void> createCategory(CategoryEntity category) async {
    state = const AsyncLoading();
    final result = await ref.read(createCategoryUsecaseProvider).call(category);
    result.fold(
      (f) => state = AsyncError(f.message, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }

  Future<void> updateCategory(CategoryEntity category) async {
    state = const AsyncLoading();
    final result = await ref.read(updateCategoryUsecaseProvider).call(category);
    result.fold(
      (f) => state = AsyncError(f.message, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }

  Future<void> deleteCategory(String id) async {
    state = const AsyncLoading();
    final result = await ref.read(deleteCategoryUsecaseProvider).call(id);
    result.fold(
      (f) => state = AsyncError(f.message, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }
}

// ─── Category Detail Future provider ─────────────────────

@riverpod
Future<CategoryEntity?> categoryDetailFuture(
  CategoryDetailFutureRef ref,
  String? id,
) async {
  if (id == null) return null;
  final categories = await ref.watch(categoryListNotifierProvider.future);
  try {
    return categories.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}

