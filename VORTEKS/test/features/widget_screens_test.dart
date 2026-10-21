import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vorteks/app_controller.dart';
import 'package:vorteks/data/models/content_models.dart';
import 'package:vorteks/data/seed/lesson_seed.dart';
import 'package:vorteks/features/assessment/assessment_screens.dart';
import 'package:vorteks/features/auth/auth_screens.dart';
import 'package:vorteks/features/dashboard/dashboard_screen.dart';
import 'package:vorteks/features/learning/lesson_detail_screen.dart';
import 'package:vorteks/features/learning/lesson_list_screen.dart';
import 'package:vorteks/features/minilab/minilab_screen.dart';
import 'package:vorteks/features/profile/profile_screens.dart';
import 'package:vorteks/core/theme/app_theme.dart';

void main() {
  late AppController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final progress = {
      for (final lesson in lessonSeed)
        lesson.id: LessonProgress(
          lessonId: lesson.id,
          completed: true,
          score: 100,
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
    };
    controller = AppController.forTesting(
      preferences: preferences,
      currentUser: const UserProfile(id: 1, fullName: 'Alya Putri', className: 'XII IPA 1', username: 'alya'),
      lessons: lessonSeed,
      assessmentQuestions: assessmentSeed,
      progress: progress,
    );
  });

  testWidgets('login validates empty local credentials', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: LoginScreen(controller: controller)));
    await tester.tap(find.text('LOGIN').last);
    await tester.pumpAndSettle();
    expect(find.text('Nama pengguna wajib diisi.'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
  });

  testWidgets('dashboard shows the active learner and live progress', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: DashboardScreen(
      controller: controller,
      onOpenLesson: (_) {},
      onOpenLessons: () {},
    )));
    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(find.text('Alya Putri'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('Lanjutkan Belajar'), findsOneWidget);
  });

  testWidgets('lesson list renders six distinct source topics and opens a selection', (tester) async {
    String? opened;
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: Scaffold(body: LessonListScreen(
      controller: controller,
      onOpenLesson: (lesson) => opened = lesson.id,
    ))));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('lesson-arus-listrik')), findsOneWidget);
    expect(find.byKey(const Key('lesson-ohmik-non-ohmik')), findsOneWidget);
    await tester.tap(find.byKey(const Key('lesson-hambatan-jenis')));
    expect(opened, 'hambatan-jenis');
  });

  testWidgets('Mini Lab arus exposes Q and t controls and the computed result', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: MiniLabScreen(lesson: lessonSeed.first)));
    await tester.pumpAndSettle();
    expect(find.text('Muatan per Waktu'), findsOneWidget);
    expect(find.text('Muatan Q'), findsOneWidget);
    expect(find.text('Waktu t'), findsOneWidget);
    expect(find.text('0.50 A'), findsOneWidget);
    // The former development note must no longer reach the student UI.
    expect(find.textContaining('belum menjadi ketentuan resmi'), findsNothing);
    expect(find.textContaining('rancangan simulasi'), findsNothing);
  });

  testWidgets('all six Mini Labs show separate instructions, goals, conclusions, and topic controls', (tester) async {
    const topicControls = [
      'Muatan Q',
      'Grafik V–I',
      'Luas penampang A',
      'Tegangan tiap lampu (model)',
      'Arus alternator Iₐ',
      'Daya P = V²/R',
    ];
    expect(lessonSeed.map((lesson) => lesson.labKind).toSet(), hasLength(6));
    for (var index = 0; index < lessonSeed.length; index++) {
      final lesson = lessonSeed[index];
      await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: MiniLabScreen(lesson: lesson)));
      await tester.pumpAndSettle();
      expect(find.text(lesson.labTitle), findsOneWidget);
      expect(find.text(lesson.labActivity), findsOneWidget);
      expect(find.text(lesson.labObjective), findsOneWidget);
      expect(find.text('Tujuan eksperimen'), findsOneWidget);
      expect(find.text('Kesimpulan'), findsOneWidget);
      expect(find.textContaining(lesson.labObservation), findsOneWidget);
      expect(find.text(topicControls[index]), findsOneWidget);
    }
  });

  testWidgets('power challenge checks the learner prediction against the power law', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: MiniLabScreen(lesson: lessonSeed.last)));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('4 kali'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('4 kali'));
    await tester.ensureVisible(find.text('Periksa Jawaban'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Periksa Jawaban'));
    await tester.pumpAndSettle();
    expect(find.textContaining('menghasilkan daya empat kali'), findsOneWidget);
  });

  testWidgets('subtopic evaluation stores answers and shows explanatory feedback', (tester) async {
    var submitted = false;
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: Scaffold(body: ListView(children: [
      LessonEvaluationCard(lesson: lessonSeed.first, onSubmit: (_) async { submitted = true; }),
    ]))));
    await tester.tap(find.text('1,5 A'));
    await tester.tap(find.text('Berlawanan arah'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Periksa Jawaban'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Periksa Jawaban'));
    await tester.pumpAndSettle();
    expect(submitted, isTrue);
    expect(find.textContaining('Jawaban benar: 2/2'), findsOneWidget);
    expect(find.textContaining('Tepat.'), findsNWidgets(2));
  });

  testWidgets('final assessment is a single scrollable ten-question form', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: FinalAssessmentScreen(controller: controller)));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('assessment-scroll-list')), findsOneWidget);
    expect(find.text('Belum dijawab: 10'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byKey(const Key('assessment-submit'))).onPressed, isNull);
    await tester.drag(find.byType(ListView), const Offset(0, -2500));
    await tester.pumpAndSettle();
    expect(find.text('Soal 10'), findsOneWidget);
  });

  testWidgets('profile shows local account details and no saved password', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: ProfileScreen(controller: controller)));
    await tester.pumpAndSettle();
    expect(find.text('PROFIL'), findsOneWidget);
    expect(find.text('@alya'), findsOneWidget);
    expect(find.text('XII IPA 1'), findsOneWidget);
    expect(find.text('Kata Sandi'), findsNothing);
    expect(find.text('EDIT PROFIL'), findsOneWidget);
  });
}
