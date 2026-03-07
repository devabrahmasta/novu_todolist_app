import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Singleton helper to open and initialise the Novu SQLite database.
///
/// Tables: `tasks`, `subtasks`, `categories`,
///         `habits`, `habit_steps`, `habit_completions`, `habit_goals`,
///         `daily_notes`.
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

    return openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
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

    // ── Habits (v2) ───────────────────────────────────────
    await _createHabitTables(db);

    // ── Daily Notes (v3) ──────────────────────────────────
    await _createDailyNotesTable(db);
  }

  /// Upgrade handler for database schema migrations.
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await _createHabitTables(db);
    }
    if (oldVersion < 3) {
      await _createDailyNotesTable(db);
    }
  }

  /// Creates all habit-related tables (v2 migration).
  static Future<void> _createHabitTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS habits (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        type INTEGER NOT NULL DEFAULT 0,
        frequency_days TEXT NOT NULL DEFAULT '[]',
        reminder_time TEXT,
        unit TEXT,
        target_value INTEGER,
        target_type INTEGER,
        tags TEXT NOT NULL DEFAULT '[]',
        priority INTEGER NOT NULL DEFAULT 1,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS habit_steps (
        id TEXT PRIMARY KEY,
        habit_id TEXT NOT NULL,
        title TEXT NOT NULL,
        order_index INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (habit_id) REFERENCES habits (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS habit_completions (
        id TEXT PRIMARY KEY,
        habit_id TEXT NOT NULL,
        date TEXT NOT NULL,
        value INTEGER NOT NULL DEFAULT 1,
        completed_at INTEGER NOT NULL,
        FOREIGN KEY (habit_id) REFERENCES habits (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS habit_goals (
        id TEXT PRIMARY KEY,
        habit_id TEXT NOT NULL,
        target_days INTEGER NOT NULL,
        start_date INTEGER NOT NULL,
        end_date INTEGER NOT NULL,
        current_progress INTEGER NOT NULL DEFAULT 0,
        status INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (habit_id) REFERENCES habits (id) ON DELETE CASCADE
      )
    ''');
  }

  /// Creates the daily_notes table (v3 migration).
  static Future<void> _createDailyNotesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS daily_notes (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL UNIQUE,
        text TEXT,
        photo_path TEXT,
        mood INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }
}
