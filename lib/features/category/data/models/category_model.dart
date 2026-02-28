import '../../domain/entities/category_entity.dart';

/// SQLite-backed category model.
class CategoryModel {
  String id;
  String name;
  String colorHex;
  String iconName;
  DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.colorHex,
    required this.iconName,
    required this.createdAt,
  });

  // ─── SQLite serialisation ──────────────────────────────

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      colorHex: map['colorHex'] as String,
      iconName: map['iconName'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
      'iconName': iconName,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}

// ─── Mapper Extensions ──────────────────────────────────

extension CategoryModelMapper on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      colorHex: colorHex,
      iconName: iconName,
      createdAt: createdAt,
    );
  }
}

extension CategoryEntityMapper on CategoryEntity {
  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      name: name,
      colorHex: colorHex,
      iconName: iconName,
      createdAt: createdAt,
    );
  }
}
