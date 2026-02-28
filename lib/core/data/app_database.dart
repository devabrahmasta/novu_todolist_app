import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Singleton helper to open and initialise the Novu SQLite database.
///
/// Tables: `tasks`, `subtasks`, `categories`.
class AppDatabase {
  AppDatabase._();

  static Database? _db;

  /// Returns the shared [Database] instance, opening it on first call.
  static Future<Database> get instance async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'novu.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    // ── Tasks ──────────────────────────────────────────────
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        categoryId TEXT,
        timeOfDay INTEGER NOT NULL DEFAULT 0,
        dueDate INTEGER,
        dueTimeHour INTEGER,
        dueTimeMinute INTEGER,
        priorityIndex INTEGER,
        status INTEGER NOT NULL DEFAULT 0,
        reminderEnabled INTEGER NOT NULL DEFAULT 0,
        reminderOffsetMinutes INTEGER NOT NULL DEFAULT 15,
        reminderCustomTime INTEGER,
        repeatType INTEGER NOT NULL DEFAULT 0,
        repeatCustomDays TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        completedAt INTEGER,
        streak INTEGER NOT NULL DEFAULT 0,
        totalCompletions INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // ── Subtasks ───────────────────────────────────────────
    await db.execute('''
      CREATE TABLE subtasks (
        id TEXT PRIMARY KEY,
        taskId TEXT NOT NULL,
        title TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        sortOrder INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');

    // ── Categories ────────────────────────────────────────
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        colorHex TEXT NOT NULL,
        iconName TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');
  }
}
