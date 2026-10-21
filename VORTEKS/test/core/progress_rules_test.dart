import 'package:flutter_test/flutter_test.dart';
import 'package:vorteks/core/constants/learning_rules.dart';
import 'package:vorteks/data/models/content_models.dart';

LessonProgress _progress(int index, {bool completed = true}) => LessonProgress(
      lessonId: 'lesson-$index',
      completed: completed,
      score: null,
      updatedAt: DateTime.utc(2026, 1, 1),
    );

void main() {
  test('progress percent counts completed topics only', () {
    expect(LearningRules.progressPercent([_progress(1), _progress(2), _progress(3, completed: false)]), 33);
  });

  test('final assessment remains locked until all six evaluations are submitted', () {
    expect(LearningRules.canStartFinalAssessment(List.generate(5, (i) => _progress(i))), isFalse);
    expect(LearningRules.canStartFinalAssessment(List.generate(6, (i) => _progress(i, completed: i != 4))), isFalse);
    expect(LearningRules.canStartFinalAssessment(List.generate(6, (i) => _progress(i))), isTrue);
  });

  test('an unset passing rule produces pending status', () {
    expect(LearningRules.assessmentPassPercent, isNull);
    expect(LearningRules.statusForPercent(100), AssessmentStatus.pendingRule);
  });
}
