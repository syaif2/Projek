import 'package:flutter/material.dart';

import '../../app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/content_models.dart';
import '../../shared/widgets/vorteks_widgets.dart';

class AssessmentLandingScreen extends StatelessWidget {
  const AssessmentLandingScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final available = controller.assessmentAvailable;
    final last = controller.latestAssessment;
    return ListView(padding: const EdgeInsets.all(18), children: [
      Text('Asesmen Akhir', textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w900)),
      const SizedBox(height: 18),
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Petunjuk pengerjaan', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.navy, fontSize: 17)),
        const SizedBox(height: 8),
        const Text('Jawablah seluruh soal berdasarkan materi yang telah dipelajari. Pilih satu jawaban yang paling tepat pada setiap soal. Kamu dapat menggulir halaman ke atas dan ke bawah untuk memeriksa seluruh soal sebelum mengirim jawaban.', style: TextStyle(height: 1.55)),
        const SizedBox(height: 16),
        _BulletItem(
          title: 'Jumlah soal',
          body: '${controller.assessmentQuestions.length} soal pilihan ganda',
        ),
        const SizedBox(height: 12),
        const _BulletItem(title: 'Pemeriksaan jawaban', body: 'Pastikan seluruh soal terisi sebelum mengirim.'),
        const SizedBox(height: 12),
        const _BulletItem(title: 'Hasil asesmen', body: 'Nilai dan status kelulusan ditampilkan setelah jawaban dikirimkan dan diperiksa.'),
      ])),
      const SizedBox(height: 20),
      if (!available)
        SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Asesmen belum tersedia', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Selesaikan evaluasi di keenam submateri terlebih dahulu (${controller.progress.values.where((item) => item.completed).length}/6 selesai).'),
        ]))
      else
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => FinalAssessmentScreen(controller: controller))),
          child: const Text('Mulai Asesmen'),
        )),
      if (last != null) ...[
        const SizedBox(height: 12),
        SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Hasil terakhir', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.navy)),
          const SizedBox(height: 5),
          Text('${last.correctCount}/${last.total} jawaban benar · ${last.percent}%'),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AssessmentResultScreen(outcome: last))), child: const Text('Lihat Hasil')),
        ])),
      ],
    ]);
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.only(top: 6), child: Text('•', style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 18))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.navy)),
          const SizedBox(height: 2),
          Text(body, style: const TextStyle(height: 1.4)),
        ])),
      ]);
}

class FinalAssessmentScreen extends StatefulWidget {
  const FinalAssessmentScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<FinalAssessmentScreen> createState() => _FinalAssessmentScreenState();
}

class _FinalAssessmentScreenState extends State<FinalAssessmentScreen> {
  final Map<String, int> _answers = {};
  bool _busy = false;
  String? _error;

  Future<void> _submit() async {
    if (_answers.length != widget.controller.assessmentQuestions.length || _busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kirim jawaban?'),
        content: const Text('Pastikan semua jawaban sudah diperiksa. Jawaban akan dinilai dan disimpan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya, kirim')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() { _busy = true; _error = null; });
    try {
      final outcome = await widget.controller.submitAssessment(_answers);
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => AssessmentResultScreen(outcome: outcome)));
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.controller.assessmentQuestions;
    final unanswered = questions.length - _answers.length;
    return Scaffold(
      appBar: AppBar(leading: const BrandBackButton(), title: const Text('ASESMEN')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(18, 8, 18, 10), child: Row(children: [
          Expanded(child: Text('Soal ${_answers.length}/${questions.length}', style: const TextStyle(fontWeight: FontWeight.w700))),
          Text('Belum dijawab: $unanswered', style: const TextStyle(color: AppColors.muted)),
        ])),
        Expanded(child: ListView.builder(
          key: const Key('assessment-scroll-list'),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          itemCount: questions.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AssessmentQuestionCard(
              number: index + 1,
              question: questions[index],
              selected: _answers[questions[index].id],
              onSelected: (value) => setState(() => _answers[questions[index].id] = value),
            ),
          ),
        )),
        if (_error != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(_error!, style: const TextStyle(color: Colors.red))),
      ]),
      bottomNavigationBar: SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton(
          key: const Key('assessment-submit'),
          onPressed: unanswered == 0 && !_busy ? _submit : null,
          child: _busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('KIRIM'),
        ),
      )),
    );
  }
}

class _AssessmentQuestionCard extends StatelessWidget {
  const _AssessmentQuestionCard({required this.number, required this.question, required this.selected, required this.onSelected});
  final int number;
  final LearningQuestion question;
  final int? selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Soal $number', style: const TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w800)),
    const SizedBox(height: 8),
    Text(question.prompt, style: const TextStyle(fontWeight: FontWeight.w700, height: 1.4)),
    const SizedBox(height: 6),
    for (var index = 0; index < question.options.length; index++)
      RadioListTile<int>(
        value: index,
        groupValue: selected,
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(question.options[index], style: const TextStyle(fontSize: 14)),
        onChanged: (value) { if (value != null) onSelected(value); },
      ),
  ]));
}

class AssessmentResultScreen extends StatelessWidget {
  const AssessmentResultScreen({super.key, required this.outcome});
  final AssessmentOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color, message) = switch (outcome.status) {
      AssessmentStatus.passed => (
        'LULUS',
        Icons.check_circle,
        AppColors.navy,
        'Kamu sudah memahami materi Listrik Arus Searah dengan baik.',
      ),
      AssessmentStatus.notPassed => (
        'BELUM LULUS',
        Icons.cancel,
        AppColors.danger,
        'Kamu belum memahami materi Listrik Arus Searah dengan baik.',
      ),
      AssessmentStatus.pendingRule => (
        'HASIL ASESMEN',
        Icons.check_circle_outline,
        AppColors.navy,
        'Kamu sudah menyelesaikan seluruh soal asesmen.',
      ),
    };
    return Scaffold(
      appBar: AppBar(leading: const BrandBackButton(), title: const Text('HASIL ASESMEN')),
      body: Center(child: Padding(padding: const EdgeInsets.all(22), child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SectionCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 132, height: 132,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, size: 74, color: Colors.white),
          ),
          const SizedBox(height: 18),
          Text(label, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 30, letterSpacing: 1)),
          const SizedBox(height: 14),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, height: 1.4)),
          const SizedBox(height: 18),
          Text('${outcome.percent}%', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w900, fontSize: 26)),
          const SizedBox(height: 4),
          Text('${outcome.correctCount} dari ${outcome.total} jawaban benar', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: const Text('Kembali'))),
        ])),
      ))),
    );
  }
}
