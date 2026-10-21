import 'package:flutter/material.dart';

import '../../app_controller.dart';
import '../../core/constants/learning_rules.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/content_models.dart';
import '../../shared/widgets/vorteks_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.controller, required this.onOpenLesson, required this.onOpenLessons});
  final AppController controller;
  final ValueChanged<LessonContent> onOpenLesson;
  final VoidCallback onOpenLessons;

  @override
  Widget build(BuildContext context) {
    final profile = controller.currentUser;
    final last = controller.lessons.firstWhere(
      (item) => item.id == controller.lastLessonId,
      orElse: () => controller.lessons.first,
    );
    final assessmentLabel = controller.latestAssessment == null
        ? (controller.assessmentAvailable ? 'Siap dikerjakan' : 'Belum tersedia')
        : controller.latestAssessment!.status == AssessmentStatus.pendingRule
            ? '${controller.latestAssessment!.percent}%'
            : controller.latestAssessment!.status == AssessmentStatus.passed
                ? 'Lulus'
                : 'Belum lulus';
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(padding: const EdgeInsets.fromLTRB(18, 14, 18, 24), children: [
        // Navy welcome banner with the cyan circuit trace from reference p.6.
        Container(
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(children: [
            Positioned.fill(
              child: CustomPaint(painter: CircuitPatternPainter(opacity: .9)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(children: [
                Text('Selamat Datang', textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, height: 1.25)),
                const SizedBox(height: 4),
                Text(profile?.fullName ?? 'Siswa', textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, height: 1.25)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 18),
        SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Materi Terakhir', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.muted, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(last.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(
              value: controller.progressPercent / 100, minHeight: 12,
              color: AppColors.navy, backgroundColor: AppColors.paleBlue))),
            const SizedBox(width: 12),
            Text('${controller.progressPercent}%', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy, fontSize: 16)),
          ]),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: () => onOpenLesson(last), child: const Text('Lanjutkan Belajar'))),
        ])),
        const SizedBox(height: 22),
        Text('Kompetensi', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _CompetencyTile(
            icon: Icons.menu_book_outlined,
            label: 'Materi',
            value: controller.progress.values.where((item) => item.completed).length >= LearningRules.totalLessons ? 'Cukup' : 'Belum Selesai',
          )),
          const SizedBox(width: 14),
          Expanded(child: _CompetencyTile(
            icon: Icons.fact_check_outlined,
            label: 'Asesmen',
            value: assessmentLabel,
          )),
        ]),
        const SizedBox(height: 18),
        OutlinedButton.icon(onPressed: onOpenLessons, icon: const Icon(Icons.grid_view_rounded), label: const Text('Lihat semua materi')),
      ]),
    );
  }
}

class _CompetencyTile extends StatelessWidget {
  const _CompetencyTile({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.navy, width: 1.4),
        ),
        child: Column(children: [
          Icon(icon, size: 44, color: AppColors.navy),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 17)),
          const SizedBox(height: 6),
          Text(value, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.ink, fontSize: 14)),
        ]),
      );
}
