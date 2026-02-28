import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category_model.dart';

/// Local data source for categories backed by sqflite.
@lazySingleton
class CategoryLocalDataSource {
  final Database _db;

  CategoryLocalDataSource(this._db);

  /// Get all categories.
  Future<List<CategoryModel>> getAllCategories() async {
    final rows = await _db.query('categories');
    return rows.map(CategoryModel.fromMap).toList();
  }

  /// Get a single category by UUID.
  Future<CategoryModel?> getCategoryById(String id) async {
    final rows = await _db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return CategoryModel.fromMap(rows.first);
  }

  /// Insert or update a category.
  Future<void> putCategory(CategoryModel category) async {
    await _db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Delete a category by UUID.
  Future<void> deleteCategory(String id) async {
    await _db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  /// Count total categories (for seed data check).
  Future<int> countCategories() async {
    final result = await _db.rawQuery('SELECT COUNT(*) as cnt FROM categories');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
