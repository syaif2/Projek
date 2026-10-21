import '../../data/models/content_models.dart';

class LearningRules {
  const LearningRules._();

  static const int totalLessons = 6;

  /// Completion currently means a submitted subtopic evaluation.
  /// The instructor should confirm whether a minimum score is also required.
  static const bool evaluationSubmissionCompletesLesson = true;

  /// Deliberately unset until the instructor approves a passing threshold.
  static const int? assessmentPassPercent = null;

  static int progressPercent(Iterable<LessonProgress> progress) {
    final completed = progress.where((item) => item.completed).length;
    return ((completed / totalLessons) * 100).round();
  }

  static bool canStartFinalAssessment(Iterable<LessonProgress> progress) {
    final items = progress.toList();
    return items.length >= totalLessons &&
        items.where((item) => item.completed).length >= totalLessons;
  }

  static AssessmentStatus statusForPercent(int percent, {int? passingPercent}) {
    if (passingPercent == null) return AssessmentStatus.pendingRule;
    return percent >= passingPercent
        ? AssessmentStatus.passed
        : AssessmentStatus.notPassed;
  }
}
