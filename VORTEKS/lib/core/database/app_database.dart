import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../data/seed/lesson_seed.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final root = await getDatabasesPath();
    _database = await openDatabase(
      '$root/vorteks.db',
      version: 1,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _createSchema,
      onOpen: _seedStaticContent,
    );
    return _database!;
  }

  Future<void> _createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        class_name TEXT NOT NULL,
        username TEXT NOT NULL COLLATE NOCASE UNIQUE,
        password_salt TEXT NOT NULL,
        password_hash TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE lessons (
        id TEXT PRIMARY KEY,
        sort_order INTEGER NOT NULL,
        title TEXT NOT NULL,
        content_json TEXT NOT NULL,
        source_pages_json TEXT NOT NULL,
        lab_kind TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE questions (
        id TEXT PRIMARY KEY,
        lesson_id TEXT,
        kind TEXT NOT NULL CHECK(kind IN ('lesson', 'assessment')),
        prompt TEXT NOT NULL,
        options_json TEXT NOT NULL,
        correct_index INTEGER NOT NULL,
        explanation TEXT NOT NULL,
        source_pages_json TEXT NOT NULL,
        FOREIGN KEY(lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE lesson_progress (
        user_id INTEGER NOT NULL,
        lesson_id TEXT NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        evaluation_score INTEGER,
        last_visited_at TEXT,
        updated_at TEXT NOT NULL,
        PRIMARY KEY(user_id, lesson_id),
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY(lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE lesson_answers (
        user_id INTEGER NOT NULL,
        lesson_id TEXT NOT NULL,
        question_id TEXT NOT NULL,
        selected_index INTEGER NOT NULL,
        is_correct INTEGER NOT NULL,
        updated_at TEXT NOT NULL,
        PRIMARY KEY(user_id, question_id),
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY(lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
        FOREIGN KEY(question_id) REFERENCES questions(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE assessment_attempts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        correct_count INTEGER NOT NULL,
        total_questions INTEGER NOT NULL,
        percent INTEGER NOT NULL,
        status TEXT NOT NULL,
        submitted_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE assessment_answers (
        attempt_id INTEGER NOT NULL,
        question_id TEXT NOT NULL,
        selected_index INTEGER NOT NULL,
        is_correct INTEGER NOT NULL,
        PRIMARY KEY(attempt_id, question_id),
        FOREIGN KEY(attempt_id) REFERENCES assessment_attempts(id) ON DELETE CASCADE,
        FOREIGN KEY(question_id) REFERENCES questions(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('CREATE INDEX idx_questions_lesson ON questions(lesson_id, kind)');
    await db.execute('CREATE INDEX idx_progress_user ON lesson_progress(user_id)');
  }

  Future<void> _seedStaticContent(Database db) async {
    await db.transaction((txn) async {
      for (final lesson in lessonSeed) {
        final content = jsonEncode(lesson.toJson());
        final lessonValues = {
          'sort_order': lesson.order,
          'title': lesson.title,
          'content_json': content,
          'source_pages_json': jsonEncode(lesson.sourcePages),
          'lab_kind': lesson.labKind,
        };
        await txn.insert('lessons', {'id': lesson.id, ...lessonValues}, conflictAlgorithm: ConflictAlgorithm.ignore);
        await txn.update('lessons', lessonValues, where: 'id = ?', whereArgs: [lesson.id]);
        for (final question in lesson.evaluation) {
          final questionValues = {
            'lesson_id': lesson.id,
            'kind': 'lesson',
            'prompt': question.prompt,
            'options_json': jsonEncode(question.options),
            'correct_index': question.correctIndex,
            'explanation': question.explanation,
            'source_pages_json': jsonEncode(question.sourcePages),
          };
          await txn.insert('questions', {'id': question.id, ...questionValues}, conflictAlgorithm: ConflictAlgorithm.ignore);
          await txn.update('questions', questionValues, where: 'id = ?', whereArgs: [question.id]);
        }
      }
      for (final question in assessmentSeed) {
        final questionValues = {
          'lesson_id': null,
          'kind': 'assessment',
          'prompt': question.prompt,
          'options_json': jsonEncode(question.options),
          'correct_index': question.correctIndex,
          'explanation': question.explanation,
          'source_pages_json': jsonEncode(question.sourcePages),
        };
        await txn.insert('questions', {'id': question.id, ...questionValues}, conflictAlgorithm: ConflictAlgorithm.ignore);
        await txn.update('questions', questionValues, where: 'id = ?', whereArgs: [question.id]);
      }
    });
  }
}
