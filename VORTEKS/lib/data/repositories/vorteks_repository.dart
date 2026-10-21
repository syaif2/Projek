import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../core/database/app_database.dart';
import '../models/content_models.dart';
import '../seed/lesson_seed.dart';

class VorteksRepository {
  VorteksRepository(this._database);

  final AppDatabase _database;
  Future<Database> get _db => _database.database;

  Future<int> createUser({
    required String fullName,
    required String className,
    required String username,
    required String salt,
    required String passwordHash,
  }) async {
    final db = await _db;
    return db.insert('users', {
      'full_name': fullName.trim(),
      'class_name': className.trim(),
      'username': username.trim().toLowerCase(),
      'password_salt': salt,
      'password_hash': passwordHash,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, Object?>?> userCredentials(String username) async {
    final rows = await (await _db).query(
      'users', where: 'username = ?', whereArgs: [username.trim().toLowerCase()], limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<UserProfile?> userById(int id) async {
    final rows = await (await _db).query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : _userFromMap(rows.first);
  }

  Future<void> updateUser({
    required int id,
    required String fullName,
    required String className,
    required String username,
    String? salt,
    String? passwordHash,
  }) async {
    final values = <String, Object?>{
      'full_name': fullName.trim(),
      'class_name': className.trim(),
      'username': username.trim().toLowerCase(),
    };
    if (salt != null && passwordHash != null) {
      values['password_salt'] = salt;
      values['password_hash'] = passwordHash;
    }
    await (await _db).update('users', values, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<LessonContent>> lessons() async {
    final rows = await (await _db).query('lessons', orderBy: 'sort_order ASC');
    if (rows.isEmpty) return lessonSeed;
    return rows.map((row) => LessonContent.fromJson(
      Map<String, Object?>.from(jsonDecode(row['content_json']! as String) as Map),
    )).toList();
  }

  Future<List<LearningQuestion>> assessmentQuestions() async {
    final rows = await (await _db).query('questions', where: 'kind = ?', whereArgs: ['assessment'], orderBy: 'id ASC');
    return rows.map(_questionFromMap).toList();
  }

  Future<Map<String, LessonProgress>> progressFor(int userId) async {
    final rows = await (await _db).query('lesson_progress', where: 'user_id = ?', whereArgs: [userId]);
    return {
      for (final row in rows)
        row['lesson_id']! as String: LessonProgress(
          lessonId: row['lesson_id']! as String,
          completed: row['completed'] == 1,
          score: row['evaluation_score'] as int?,
          updatedAt: DateTime.tryParse(row['updated_at']! as String) ?? DateTime.fromMillisecondsSinceEpoch(0),
        ),
    };
  }

  Future<void> recordLessonVisit(int userId, String lessonId) async {
    final now = DateTime.now().toIso8601String();
    final db = await _db;
    await db.transaction((txn) async {
      final existing = await txn.query('lesson_progress', where: 'user_id = ? AND lesson_id = ?', whereArgs: [userId, lessonId], limit: 1);
      if (existing.isEmpty) {
        await txn.insert('lesson_progress', {'user_id': userId, 'lesson_id': lessonId, 'completed': 0, 'last_visited_at': now, 'updated_at': now});
      } else {
        await txn.update('lesson_progress', {'last_visited_at': now, 'updated_at': now}, where: 'user_id = ? AND lesson_id = ?', whereArgs: [userId, lessonId]);
      }
    });
  }

  Future<void> saveLessonEvaluation({
    required int userId,
    required String lessonId,
    required Map<String, int> answers,
    required int score,
    required List<LearningQuestion> questions,
    required bool completesLesson,
  }) async {
    final db = await _db;
    final now = DateTime.now().toIso8601String();
    await db.transaction((txn) async {
      for (final question in questions) {
        final selected = answers[question.id];
        if (selected == null) continue;
        await txn.insert('lesson_answers', {
          'user_id': userId,
          'lesson_id': lessonId,
          'question_id': question.id,
          'selected_index': selected,
          'is_correct': selected == question.correctIndex ? 1 : 0,
          'updated_at': now,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      final existing = await txn.query('lesson_progress', where: 'user_id = ? AND lesson_id = ?', whereArgs: [userId, lessonId], limit: 1);
      final isComplete = completesLesson || (existing.isNotEmpty && existing.first['completed'] == 1);
      final progressValues = {
        'completed': isComplete ? 1 : 0,
        'evaluation_score': score,
        'last_visited_at': now,
        'updated_at': now,
      };
      if (existing.isEmpty) {
        await txn.insert('lesson_progress', {'user_id': userId, 'lesson_id': lessonId, ...progressValues});
      } else {
        await txn.update('lesson_progress', progressValues, where: 'user_id = ? AND lesson_id = ?', whereArgs: [userId, lessonId]);
      }
    });
  }

  Future<int> saveAssessment({
    required int userId,
    required AssessmentOutcome outcome,
    required Map<String, int> answers,
    required List<LearningQuestion> questions,
  }) async {
    final db = await _db;
    return db.transaction((txn) async {
      final attemptId = await txn.insert('assessment_attempts', {
        'user_id': userId,
        'correct_count': outcome.correctCount,
        'total_questions': outcome.total,
        'percent': outcome.percent,
        'status': outcome.status.name,
        'submitted_at': DateTime.now().toIso8601String(),
      });
      for (final question in questions) {
        final selected = answers[question.id];
        if (selected == null) continue;
        await txn.insert('assessment_answers', {
          'attempt_id': attemptId,
          'question_id': question.id,
          'selected_index': selected,
          'is_correct': selected == question.correctIndex ? 1 : 0,
        });
      }
      return attemptId;
    });
  }

  Future<AssessmentOutcome?> latestAssessmentFor(int userId) async {
    final rows = await (await _db).query(
      'assessment_attempts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'submitted_at DESC, id DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    final status = AssessmentStatus.values.firstWhere(
      (value) => value.name == row['status'],
      orElse: () => AssessmentStatus.pendingRule,
    );
    return AssessmentOutcome(
      correctCount: row['correct_count']! as int,
      total: row['total_questions']! as int,
      percent: row['percent']! as int,
      status: status,
    );
  }

  UserProfile _userFromMap(Map<String, Object?> row) => UserProfile(
        id: row['id']! as int,
        fullName: row['full_name']! as String,
        className: row['class_name']! as String,
        username: row['username']! as String,
      );

  LearningQuestion _questionFromMap(Map<String, Object?> row) => LearningQuestion(
        id: row['id']! as String,
        prompt: row['prompt']! as String,
        options: List<String>.from(jsonDecode(row['options_json']! as String) as List),
        correctIndex: row['correct_index']! as int,
        explanation: row['explanation']! as String,
        sourcePages: List<int>.from(jsonDecode(row['source_pages_json']! as String) as List),
      );
}
