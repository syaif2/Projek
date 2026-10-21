import 'package:flutter_test/flutter_test.dart';
import 'package:vorteks/core/utils/physics_calculations.dart';
import 'package:vorteks/data/models/content_models.dart';
import 'package:vorteks/data/seed/lesson_seed.dart';

void main() {
  test('scores the ten-question bank and withholds status until a rule is set', () {
    final answers = {for (final question in assessmentSeed) question.id: question.correctIndex};
    final fullScore = PhysicsCalculations.assess(questions: assessmentSeed, answers: answers);
    expect(assessmentSeed.length, 10);
    expect(fullScore.correctCount, 10);
    expect(fullScore.percent, 100);
    expect(fullScore.status, AssessmentStatus.pendingRule);

    answers[assessmentSeed.first.id] = (assessmentSeed.first.correctIndex + 1) % assessmentSeed.first.options.length;
    final partial = PhysicsCalculations.assess(questions: assessmentSeed, answers: answers, passingPercent: 70);
    expect(partial.correctCount, 9);
    expect(partial.status, AssessmentStatus.passed);
  });
}
