import 'package:flutter/material.dart';

import '../../app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/physics_calculations.dart';
import '../../data/models/content_models.dart';
import '../../shared/widgets/circuit_painters.dart';
import '../../shared/widgets/vorteks_widgets.dart';
import '../minilab/minilab_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  const LessonDetailScreen({super.key, required this.controller, required this.lesson});
  final AppController controller;
  final LessonContent lesson;

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.controller.visitLesson(widget.lesson.id));
  }

  void _openLab() => Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => MiniLabScreen(lesson: widget.lesson),
  ));

  void _openNeighbor(int offset) {
    final index = widget.controller.lessons.indexOf(widget.lesson);
    final nextIndex = index + offset;
    if (nextIndex < 0 || nextIndex >= widget.controller.lessons.length) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => LessonDetailScreen(controller: widget.controller, lesson: widget.controller.lessons[nextIndex]),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: const BrandBackButton(), title: Text(widget.lesson.title)),
        body: PageBody(children: [
          SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionTitle('Konteks', icon: Icons.lightbulb_outline),
            const SizedBox(height: 10),
            Text(widget.lesson.context, style: const TextStyle(height: 1.55)),
          ])),
          const SizedBox(height: 12),
          SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionTitle('Tujuan Pembelajaran', icon: Icons.flag_outlined),
            const SizedBox(height: 8),
            for (final objective in widget.lesson.objectives)
              Padding(padding: const EdgeInsets.only(top: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('•  ', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.cyan)),
                Expanded(child: Text(objective, style: const TextStyle(height: 1.4))),
              ])),
          ])),
          const SizedBox(height: 12),
          for (final section in widget.lesson.sections) ...[
            SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(section.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(section.body, style: const TextStyle(height: 1.5)),
              if (section.formula != null) ...[
                const SizedBox(height: 12),
                Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(12)),
                  child: Text(section.formula!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800, fontSize: 17))),
              ],
            ])),
            const SizedBox(height: 12),
          ],
          SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionTitle('Visualisasi', icon: Icons.cable_outlined),
            const SizedBox(height: 12),
            LessonVisual(labKind: widget.lesson.labKind),
          ])),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _openLab, icon: const Icon(Icons.science_outlined), label: Text('Buka Mini Lab: ${widget.lesson.labTitle}'))),
          const SizedBox(height: 12),
          LessonEvaluationCard(
            key: Key('evaluation-${widget.lesson.id}'),
            lesson: widget.lesson,
            onSubmit: (answers) => widget.controller.submitLessonEvaluation(lesson: widget.lesson, answers: answers),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: widget.lesson.order == 1 ? null : () => _openNeighbor(-1), child: const Text('Kembali'))),
            const SizedBox(width: 12),
            Expanded(child: FilledButton(onPressed: widget.lesson.order == widget.controller.lessons.length ? null : () => _openNeighbor(1), child: const Text('Lanjut'))),
          ]),
          const SizedBox(height: 20),
          Text('Sumber buku: Fisika untuk SMA/MA Kelas XII, Bab 2, hlm. ${widget.lesson.sourcePages.join(', ')}.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted)),
        ]),
      );
}

class LessonEvaluationCard extends StatefulWidget {
  const LessonEvaluationCard({super.key, required this.lesson, required this.onSubmit});
  final LessonContent lesson;
  final Future<void> Function(Map<String, int> answers) onSubmit;

  @override
  State<LessonEvaluationCard> createState() => _LessonEvaluationCardState();
}

class _LessonEvaluationCardState extends State<LessonEvaluationCard> {
  final Map<String, int> _answers = {};
  bool _submitted = false;
  bool _busy = false;
  String? _error;

  Future<void> _submit() async {
    if (_answers.length != widget.lesson.evaluation.length || _busy) return;
    setState(() { _busy = true; _error = null; });
    try {
      await widget.onSubmit(_answers);
      if (mounted) setState(() => _submitted = true);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final outcome = _submitted ? PhysicsCalculations.assess(questions: widget.lesson.evaluation, answers: _answers) : null;
    return SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionTitle('Evaluasi Submateri', icon: Icons.quiz_outlined),
      const SizedBox(height: 4),
      const Text('Jawab pertanyaan khusus topik ini. Setelah dikirim, jawaban dan progres tersimpan di perangkat.'),
      const SizedBox(height: 12),
      for (var i = 0; i < widget.lesson.evaluation.length; i++) ...[
        _LessonQuestionTile(
          number: i + 1,
          question: widget.lesson.evaluation[i],
          selected: _answers[widget.lesson.evaluation[i].id],
          submitted: _submitted,
          onSelected: (index) => setState(() => _answers[widget.lesson.evaluation[i].id] = index),
        ),
        const SizedBox(height: 10),
      ],
      if (outcome != null) ...[
        Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.paleBlue, borderRadius: BorderRadius.circular(12)),
          child: Text('Jawaban benar: ${outcome.correctCount}/${outcome.total} (${outcome.percent}%). Progres submateri tersimpan.', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700))),
      ],
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: const TextStyle(color: Colors.red))),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: _submitted || _answers.length != widget.lesson.evaluation.length || _busy ? null : _submit,
        child: _busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(_submitted ? 'Tersimpan' : 'Periksa Jawaban'))),
    ]));
  }
}

class _LessonQuestionTile extends StatelessWidget {
  const _LessonQuestionTile({required this.number, required this.question, required this.selected, required this.submitted, required this.onSelected});
  final int number;
  final LearningQuestion question;
  final int? selected;
  final bool submitted;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('$number. ${question.prompt}', style: const TextStyle(fontWeight: FontWeight.w700, height: 1.4)),
    const SizedBox(height: 5),
    for (var i = 0; i < question.options.length; i++)
      RadioListTile<int>(
        value: i,
        groupValue: selected,
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(question.options[i], style: const TextStyle(fontSize: 14)),
        onChanged: submitted ? null : (value) { if (value != null) onSelected(value); },
      ),
    if (submitted)
      Padding(padding: const EdgeInsets.only(left: 4, bottom: 6), child: Text(
        selected == question.correctIndex ? 'Tepat. ${question.explanation}' : 'Belum tepat. ${question.explanation}',
        style: TextStyle(color: selected == question.correctIndex ? AppColors.success : AppColors.warning, height: 1.35),
      )),
  ]);
}

class LessonVisual extends StatelessWidget {
  const LessonVisual({super.key, required this.labKind});
  final String labKind;

  @override
  Widget build(BuildContext context) {
    switch (labKind) {
      case 'current':
        return const CircuitDiagram(caption: 'Arus konvensional dan gerak elektron berlawanan arah.');
      case 'iv-graph':
        return Column(children: [
          SizedBox(height: 160, width: double.infinity, child: CustomPaint(painter: const ConceptIvPainter())),
          const Text('Grafik tegangan (V) terhadap arus (I) untuk resistor ohmik dan LED.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.muted)),
        ]);
      case 'resistivity':
        return const _WireVisual();
      case 'topology':
        return const Column(children: [CircuitDiagram(caption: 'Bandingkan jalur satu lintasan dan jalur bercabang.'), Text('Susunan seri dan paralel memiliki pola tegangan dan arus yang berbeda.', textAlign: TextAlign.center)]);
      case 'kirchhoff':
        return SizedBox(height: 160, width: double.infinity, child: CustomPaint(painter: MixedCircuitPainter()));
      default:
        return const Column(children: [CircuitDiagram(caption: 'Daya berkaitan dengan tegangan dan arus.'), Text('P = V I', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.navy))]);
    }
  }
}

class ConceptIvPainter extends CustomPainter {
  const ConceptIvPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final area = Rect.fromLTWH(34, 10, size.width - 48, size.height - 36);
    final axis = Paint()..color = AppColors.ink..strokeWidth = 1.5;
    canvas.drawLine(Offset(area.left, area.bottom), Offset(area.right, area.bottom), axis);
    canvas.drawLine(Offset(area.left, area.bottom), Offset(area.left, area.top), axis);
    final linear = Path()..moveTo(area.left, area.bottom)..lineTo(area.right, area.top + 8);
    final curved = Path()..moveTo(area.left, area.bottom)..cubicTo(area.left + area.width * .48, area.bottom - 7, area.right - area.width * .25, area.top + area.height * .55, area.right, area.top + 3);
    canvas.drawPath(linear, Paint()..color = AppColors.navy..strokeWidth = 3..style = PaintingStyle.stroke);
    canvas.drawPath(curved, Paint()..color = AppColors.cyan..strokeWidth = 3..style = PaintingStyle.stroke);
    _label(canvas, 'I', Offset(4, area.top));
    _label(canvas, 'V', Offset(area.right - 3, area.bottom + 5));
    _label(canvas, 'Resistor', Offset(area.left + 12, area.top + 6));
    _label(canvas, 'LED', Offset(area.left + area.width * .55, area.top + area.height * .45));
  }

  void _label(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(text: TextSpan(text: text, style: const TextStyle(fontSize: 10, color: AppColors.muted)), textDirection: TextDirection.ltr)..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WireVisual extends StatelessWidget {
  const _WireVisual();
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    for (final diameter in [30.0, 48.0, 68.0])
      Column(children: [
        Container(width: diameter, height: diameter, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.paleBlue, border: Border.all(color: AppColors.navy, width: 2))),
        const SizedBox(height: 6), Text('${[0.1, 0.5, 1.0][[30.0, 48.0, 68.0].indexOf(diameter)]} mm', style: const TextStyle(fontSize: 12, color: AppColors.navy)),
      ]),
  ]);
}
