import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/learning_rules.dart';
import 'core/database/app_database.dart';
import 'core/utils/physics_calculations.dart';
import 'data/models/content_models.dart';
import 'data/repositories/vorteks_repository.dart';
import 'data/seed/lesson_seed.dart';
import 'data/services/password_service.dart';

class AppController extends ChangeNotifier {
  AppController._({
    required VorteksRepository repository,
    required SharedPreferences preferences,
    required PasswordService passwordService,
  })  : _repository = repository,
        _preferences = preferences,
        _passwordService = passwordService;

  @visibleForTesting
  AppController.forTesting({
    required SharedPreferences preferences,
    VorteksRepository? repository,
    PasswordService? passwordService,
    this.currentUser,
    List<LessonContent>? lessons,
    List<LearningQuestion>? assessmentQuestions,
    Map<String, LessonProgress>? progress,
    this.latestAssessment,
    this.lastLessonId,
  })  : _repository = repository ?? VorteksRepository(AppDatabase.instance),
        _preferences = preferences,
        _passwordService = passwordService ?? PasswordService() {
    this.lessons = lessons ?? lessonSeed;
    this.assessmentQuestions = assessmentQuestions ?? assessmentSeed;
    this.progress = progress ?? {};
  }

  final VorteksRepository _repository;
  final SharedPreferences _preferences;
  final PasswordService _passwordService;

  UserProfile? currentUser;
  List<LessonContent> lessons = lessonSeed;
  List<LearningQuestion> assessmentQuestions = assessmentSeed;
  Map<String, LessonProgress> progress = {};
  AssessmentOutcome? latestAssessment;
  String? lastLessonId;

  List<LessonProgress> get progressItems => progress.values.toList();
  int get progressPercent => LearningRules.progressPercent(progressItems);
  bool get assessmentAvailable => LearningRules.canStartFinalAssessment(progressItems);

  static Future<AppController> create({
    AppDatabase? database,
    SharedPreferences? preferences,
    PasswordService? passwordService,
  }) async {
    final actualDb = database ?? AppDatabase.instance;
    await actualDb.database;
    final actualPreferences = preferences ?? await SharedPreferences.getInstance();
    final controller = AppController._(
      repository: VorteksRepository(actualDb),
      preferences: actualPreferences,
      passwordService: passwordService ?? PasswordService(),
    );
    await controller._restoreSession();
    return controller;
  }

  Future<void> _restoreSession() async {
    lessons = await _repository.lessons();
    assessmentQuestions = await _repository.assessmentQuestions();
    final userId = _preferences.getInt('session_user_id');
    if (userId != null) {
      currentUser = await _repository.userById(userId);
      if (currentUser != null) {
        lastLessonId = _preferences.getString('last_lesson_id_$userId');
        await _refreshUserData();
      }
      if (currentUser == null) await _preferences.remove('session_user_id');
    }
  }

  Future<void> register({
    required String fullName,
    required String className,
    required String username,
    required String password,
  }) async {
    if (await _repository.userCredentials(username) != null) {
      throw const AuthException('Nama pengguna sudah digunakan.');
    }
    final digest = await _passwordService.derive(password);
    try {
      final id = await _repository.createUser(
        fullName: fullName,
        className: className,
        username: username,
        salt: digest.salt,
        passwordHash: digest.hash,
      );
      await _establishSession(id);
    } on Exception catch (error) {
      if (error.toString().toLowerCase().contains('unique')) {
        throw const AuthException('Nama pengguna sudah digunakan.');
      }
      rethrow;
    }
  }

  Future<void> login({required String username, required String password}) async {
    final row = await _repository.userCredentials(username);
    if (row == null) throw const AuthException('Nama pengguna atau kata sandi tidak cocok.');
    final digest = PasswordDigest(
      salt: row['password_salt']! as String,
      hash: row['password_hash']! as String,
    );
    if (!await _passwordService.verify(password, digest)) {
      throw const AuthException('Nama pengguna atau kata sandi tidak cocok.');
    }
    await _establishSession(row['id']! as int);
  }

  Future<void> _establishSession(int userId) async {
    currentUser = await _repository.userById(userId);
    if (currentUser == null) throw const AuthException('Akun lokal tidak ditemukan.');
    lastLessonId = _preferences.getString('last_lesson_id_$userId');
    await _preferences.setInt('session_user_id', userId);
    await _refreshUserData();
    notifyListeners();
  }

  Future<void> logout() async {
    await _preferences.remove('session_user_id');
    currentUser = null;
    progress = {};
    latestAssessment = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String fullName,
    required String className,
    required String username,
    String? newPassword,
  }) async {
    final user = currentUser;
    if (user == null) throw const AuthException('Sesi pengguna berakhir.');
    final existing = await _repository.userCredentials(username);
    if (existing != null && existing['id'] != user.id) {
      throw const AuthException('Nama pengguna sudah digunakan.');
    }
    PasswordDigest? digest;
    if (newPassword != null && newPassword.isNotEmpty) {
      digest = await _passwordService.derive(newPassword);
    }
    await _repository.updateUser(
      id: user.id,
      fullName: fullName,
      className: className,
      username: username,
      salt: digest?.salt,
      passwordHash: digest?.hash,
    );
    currentUser = await _repository.userById(user.id);
    notifyListeners();
  }

  Future<void> refresh() async {
    if (currentUser != null) await _refreshUserData();
    notifyListeners();
  }

  Future<void> _refreshUserData() async {
    final userId = currentUser!.id;
    progress = await _repository.progressFor(userId);
    latestAssessment = await _repository.latestAssessmentFor(userId);
  }

  Future<void> visitLesson(String lessonId) async {
    final user = currentUser;
    if (user == null) return;
    lastLessonId = lessonId;
    await _preferences.setString('last_lesson_id_${user.id}', lessonId);
    await _repository.recordLessonVisit(user.id, lessonId);
    await refresh();
  }

  Future<void> submitLessonEvaluation({
    required LessonContent lesson,
    required Map<String, int> answers,
  }) async {
    final user = currentUser;
    if (user == null) throw const AuthException('Sesi pengguna berakhir.');
    final outcome = PhysicsCalculations.assess(
      questions: lesson.evaluation,
      answers: answers,
    );
    await _repository.saveLessonEvaluation(
      userId: user.id,
      lessonId: lesson.id,
      answers: answers,
      score: outcome.percent,
      questions: lesson.evaluation,
      completesLesson: LearningRules.evaluationSubmissionCompletesLesson,
    );
    await refresh();
  }

  Future<AssessmentOutcome> submitAssessment(Map<String, int> answers) async {
    final user = currentUser;
    if (user == null) throw const AuthException('Sesi pengguna berakhir.');
    if (!assessmentAvailable) throw const AuthException('Selesaikan enam evaluasi submateri terlebih dahulu.');
    final outcome = PhysicsCalculations.assess(
      questions: assessmentQuestions,
      answers: answers,
      passingPercent: LearningRules.assessmentPassPercent,
    );
    await _repository.saveAssessment(
      userId: user.id,
      outcome: outcome,
      answers: answers,
      questions: assessmentQuestions,
    );
    latestAssessment = outcome;
    notifyListeners();
    return outcome;
  }
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
