import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_entity.freezed.dart';

/// Category entity — pure domain.
@freezed
class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required String id,
    required String name,
    required String colorHex, // e.g. "FF8C7DFF"
    required String iconName, // icon identifier string
    required DateTime createdAt,
  }) = _CategoryEntity;
}
