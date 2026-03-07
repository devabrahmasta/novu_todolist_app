// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllCategoriesUsecaseHash() =>
    r'3fc61c6bde71569d6c62a92555a17b46645edc4f';

/// See also [getAllCategoriesUsecase].
@ProviderFor(getAllCategoriesUsecase)
final getAllCategoriesUsecaseProvider =
    AutoDisposeProvider<GetAllCategoriesUsecase>.internal(
  getAllCategoriesUsecase,
  name: r'getAllCategoriesUsecaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllCategoriesUsecaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllCategoriesUsecaseRef
    = AutoDisposeProviderRef<GetAllCategoriesUsecase>;
String _$createCategoryUsecaseHash() =>
    r'698712d4c9f6a02968a6e88b2d7e08744cb3235d';

/// See also [createCategoryUsecase].
@ProviderFor(createCategoryUsecase)
final createCategoryUsecaseProvider =
    AutoDisposeProvider<CreateCategoryUsecase>.internal(
  createCategoryUsecase,
  name: r'createCategoryUsecaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createCategoryUsecaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CreateCategoryUsecaseRef
    = AutoDisposeProviderRef<CreateCategoryUsecase>;
String _$updateCategoryUsecaseHash() =>
    r'662d6b0e0f90673537c597a790f7ff52d01161c0';

/// See also [updateCategoryUsecase].
@ProviderFor(updateCategoryUsecase)
final updateCategoryUsecaseProvider =
    AutoDisposeProvider<UpdateCategoryUsecase>.internal(
  updateCategoryUsecase,
  name: r'updateCategoryUsecaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateCategoryUsecaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpdateCategoryUsecaseRef
    = AutoDisposeProviderRef<UpdateCategoryUsecase>;
String _$deleteCategoryUsecaseHash() =>
    r'c64a45616fd16fd6e4240aed0ddd101da494925f';

/// See also [deleteCategoryUsecase].
@ProviderFor(deleteCategoryUsecase)
final deleteCategoryUsecaseProvider =
    AutoDisposeProvider<DeleteCategoryUsecase>.internal(
  deleteCategoryUsecase,
  name: r'deleteCategoryUsecaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteCategoryUsecaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DeleteCategoryUsecaseRef
    = AutoDisposeProviderRef<DeleteCategoryUsecase>;
String _$categoryDetailFutureHash() =>
    r'551fec285b0974ef9bea27e2f8bf114e44b51561';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [categoryDetailFuture].
@ProviderFor(categoryDetailFuture)
const categoryDetailFutureProvider = CategoryDetailFutureFamily();

/// See also [categoryDetailFuture].
class CategoryDetailFutureFamily extends Family<AsyncValue<CategoryEntity?>> {
  /// See also [categoryDetailFuture].
  const CategoryDetailFutureFamily();

  /// See also [categoryDetailFuture].
  CategoryDetailFutureProvider call(
    String? id,
  ) {
    return CategoryDetailFutureProvider(
      id,
    );
  }

  @override
  CategoryDetailFutureProvider getProviderOverride(
    covariant CategoryDetailFutureProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryDetailFutureProvider';
}

/// See also [categoryDetailFuture].
class CategoryDetailFutureProvider
    extends AutoDisposeFutureProvider<CategoryEntity?> {
  /// See also [categoryDetailFuture].
  CategoryDetailFutureProvider(
    String? id,
  ) : this._internal(
          (ref) => categoryDetailFuture(
            ref as CategoryDetailFutureRef,
            id,
          ),
          from: categoryDetailFutureProvider,
          name: r'categoryDetailFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryDetailFutureHash,
          dependencies: CategoryDetailFutureFamily._dependencies,
          allTransitiveDependencies:
              CategoryDetailFutureFamily._allTransitiveDependencies,
          id: id,
        );

  CategoryDetailFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String? id;

  @override
  Override overrideWith(
    FutureOr<CategoryEntity?> Function(CategoryDetailFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryDetailFutureProvider._internal(
        (ref) => create(ref as CategoryDetailFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CategoryEntity?> createElement() {
    return _CategoryDetailFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryDetailFutureProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CategoryDetailFutureRef on AutoDisposeFutureProviderRef<CategoryEntity?> {
  /// The parameter `id` of this provider.
  String? get id;
}

class _CategoryDetailFutureProviderElement
    extends AutoDisposeFutureProviderElement<CategoryEntity?>
    with CategoryDetailFutureRef {
  _CategoryDetailFutureProviderElement(super.provider);

  @override
  String? get id => (origin as CategoryDetailFutureProvider).id;
}

String _$categoryListNotifierHash() =>
    r'3b06f6c6c91f7a3c462ee6ca063d82f7b089a892';

/// See also [CategoryListNotifier].
@ProviderFor(CategoryListNotifier)
final categoryListNotifierProvider = AutoDisposeAsyncNotifierProvider<
    CategoryListNotifier, List<CategoryEntity>>.internal(
  CategoryListNotifier.new,
  name: r'categoryListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CategoryListNotifier = AutoDisposeAsyncNotifier<List<CategoryEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
