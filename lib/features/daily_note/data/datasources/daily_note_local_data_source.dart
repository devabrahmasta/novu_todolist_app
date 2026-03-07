import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../models/daily_note_model.dart';

/// Local data source for daily notes backed by sqflite.
@lazySingleton
class DailyNoteLocalDataSource {
  final Database _db;

  DailyNoteLocalDataSource(this._db);

  /// Get a note by date string ("yyyy-MM-dd").
  Future<DailyNoteModel?> getNoteByDate(String date) async {
    final rows = await _db.query(
      'daily_notes',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return DailyNoteModel.fromMap(rows.first);
  }

  /// Insert or update a note (upsert by id).
  Future<void> upsertNote(DailyNoteModel note) async {
    await _db.insert(
      'daily_notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all notes ordered by date descending.
  Future<List<DailyNoteModel>> getAllNotes() async {
    final rows = await _db.query('daily_notes', orderBy: 'date DESC');
    return rows.map(DailyNoteModel.fromMap).toList();
  }
}
